Pod::Spec.new do |s|
  s.name     = 'MBFaker'
  s.version  = '0.2.0'
  s.platform = :ios, '8.0'
  s.license  = 'MIT'
  s.summary  = 'Library that generates fake data.'
  s.description = 'This library is a port of Ruby Faker library that generates fake data.'
  s.homepage = 'https://github.com/WPMedia/MBFaker'
  s.author   = { 'Michał Banasiak' => 'm.banasiak@icloud.com', 'Sean Soper' => 'sean.soper@washpost.com' }
  s.source   = { :git => 'https://github.com/WPMedia/MBFaker.git', :tag => s.version.to_s }
  s.source_files = 'MBFaker/Classes'
  s.resource_bundles = { 'MBFaker' => 'MBFaker/Locales' }
end