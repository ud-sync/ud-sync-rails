require 'rails/generators/active_record'

class Doorkeeper::MigrationGenerator < ::Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.expand_path('../templates', __FILE__)
  desc 'Installs UDSync migration file.'

  def install
    migration_template 'migration.rb', 'db/migrate/create_ud_sync_tables.rb'
    template 'initializer.rb', 'config/initializers/ud_sync.rb'
  end

  def self.next_migration_number(dirname)
    ActiveRecord::Generators::Base.next_migration_number(dirname)
  end
end
