require 'spec_integration_helper'

RSpec.describe 'db/migrate/20160130183000_create_ud_sync_tables.rb', :use_fixtures do
  let(:migration_path) do
    File.expand_path('../../../db/migrate/20160130183000_create_ud_sync_tables.rb', __FILE__)
  end
  let(:connection) { ActiveRecord::Base.connection }

  def run_migration
    load migration_path
    migration = CreateUdSyncTables.new
    ActiveRecord::Migration.suppress_messages { migration.migrate(:up) }
  end

  after { Object.send(:remove_const, :CreateUdSyncTables) if defined?(CreateUdSyncTables) }

  it 'is a versioned migration' do
    load migration_path

    expect(CreateUdSyncTables.ancestors).to include(ActiveRecord::Migration::Compatibility::V4_2)
  end

  context 'when ud_sync_operations already exists' do
    it 'does not raise and leaves the table intact' do
      columns_before = connection.columns(:ud_sync_operations).map(&:name)
      UdSync::Operation.create!(name: 'save', external_id: 'abc', entity_name: 'Post')

      expect { run_migration }.not_to raise_error

      expect(connection.columns(:ud_sync_operations).map(&:name)).to eq columns_before
      expect(UdSync::Operation.count).to eq 1
    end
  end

  context 'when ud_sync_operations does not exist' do
    before { connection.drop_table(:ud_sync_operations) }

    it 'creates the table' do
      run_migration

      expect(connection.columns(:ud_sync_operations).map(&:name)).to eq(
        %w[id name record_id external_id owner_id entity_name created_at updated_at]
      )
    end
  end
end
