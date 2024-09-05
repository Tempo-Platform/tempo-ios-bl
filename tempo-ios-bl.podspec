Pod::Spec.new do |spec|
  spec.name             = 'tempo-ios-bl'
  spec.version          = '1.0.0-rc.0'
  spec.swift_version    = '5.6'
  spec.author           = { 'Tempo Engineering' => 'development@tempoplatform.com' }
  spec.license          = { :type => 'MIT', :file => 'tempo-ios-bl/MIT-LICENSE.txt' }
  spec.homepage         = 'https://github.com/Tempo-Platform/tempo-ios-bl'
  spec.source           = { :git => 'https://github.com/Tempo-Platform/tempo-ios-bl.git', :tag => spec.version.to_s }
  spec.summary          = 'Tempo Branded Levels SDK to display in-game content'

  spec.ios.deployment_target = '11.0'

  spec.source_files  = 'tempo-ios-bl/**/*.{h,m,swift,txt}'
  spec.resource_bundles = {
    'tempo-ios-bl' => ['tempo-ios-bl/Resources/**/*']
  }
  
  spec.pod_target_xcconfig = { 'PRODUCT_BUNDLE_IDENTIFIER' => 'com.tempoplatform.tempo-ios-bl' }
end
