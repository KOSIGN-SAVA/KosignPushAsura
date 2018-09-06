Pod::Spec.new do |s|
  s.name             = 'KosignPushAsura'
  s.version          = '0.1.3'
  s.summary          = 'Push pung Push Push note'

  s.description      = <<-DESC
This is Kosign push notification service internal the company.
                       DESC

  s.homepage         = 'https://github.com/KOSIGN-SAVA/KosignPushAsura'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Vansa Pha' => 'vs.lov.rs@gmail.com' }
  s.source           = { :git => 'https://github.com/KOSIGN-SAVA/KosignPushAsura.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.source_files = 'KosignPushAsura/Classes/**/*'

  # s.resource_bundles = {
  #   'KosignPushAsura' => ['KosignPushAsura/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
#   s.frameworks = 'UserNotifications'
  # s.dependency 'AFNetworking', '~> 2.3'
end
