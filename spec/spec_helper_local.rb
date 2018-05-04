RSpec.configure do |c|
  c.after(:suite) do
    RSpec::Puppet::Coverage.report!(100)
  end
end
