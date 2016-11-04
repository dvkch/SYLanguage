Pod::Spec.new do |s|
  s.ios.deployment_target  = '6.0'
  s.tvos.deployment_target = '9.0'
  s.name     = 'SYLanguage'
  s.version  = '1.0.0'
  s.license  = 'Custom'
  s.summary  = 'Switch interface language at runtime'
  s.homepage = 'https://github.com/dvkch/SYLanguage'
  s.author   = { 'Stan Chevallier' => 'contact@stanislaschevallier.fr' }
  s.source   = { :git => 'https://github.com/dvkch/SYLanguage.git', :tag => s.version.to_s }
  s.source_files = 'SYLanguage/*.{h,m,c}'

  s.requires_arc = true
  s.xcconfig = { 'CLANG_MODULES_AUTOLINK' => 'YES' }
end
