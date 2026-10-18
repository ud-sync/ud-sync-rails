require 'open3'
require 'rbconfig'

RSpec.describe 'requiring ud_sync' do
  let(:lib_path) { File.expand_path('../../../lib', __FILE__) }

  def run_ruby(script)
    Open3.capture2e(RbConfig.ruby, '-rbundler/setup', '-I', lib_path, '-e', script)
  end

  # ActiveRecord.autoload?(:Base) is nil once ActiveRecord::Base has loaded.
  it 'does not load ActiveRecord::Base' do
    output, status = run_ruby(<<~RUBY)
      require 'rails'
      require 'active_record/railtie'
      require 'ud_sync'
      puts ActiveRecord.autoload?(:Base).nil?
    RUBY

    expect(status).to be_success, output
    expect(output.lines.last.strip).to eq 'false'
  end

  it 'adds the ud_sync macro when ActiveRecord::Base loads' do
    output, status = run_ruby(<<~RUBY)
      require 'rails'
      require 'active_record/railtie'
      require 'ud_sync'
      puts ActiveRecord::Base.respond_to?(:ud_sync)
    RUBY

    expect(status).to be_success, output
    expect(output.lines.last.strip).to eq 'true'
  end
end
