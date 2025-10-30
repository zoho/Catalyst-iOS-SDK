#
# Be sure to run `pod lib lint Catalyst.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZCatalyst'
  s.version          = '3.0.0'
  s.summary          = 'A short description of ZCatalyst.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

 
  s.homepage         = 'https://github.com/zoho/Catalyst-iOS-SDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Zoho Corporation': '' }
  s.source           = { :git => 'https://github.com/zoho/Catalyst-iOS-SDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.dependency 'ZohoPortalAuth', '1.0.5'
  s.static_framework = true
#  s.dependency 'Apptics-SDK/Core', '1.0.0'
#  s.dependency 'Apptics-SDK/CrashKit', '1.0.0'
#  s.dependency 'Apptics-SDK/Scripts', '1.0.0'
#  s.dependency 'AppticsRateUs', '1.0.0'
#  s.dependency 'AppticsFeedbackKit', '1.0.0'

  s.public_header_files = "Pod/Classes/**/*.h"
  
  s.source_files = 'ZCatalyst/Classes/**/*'
  #  pod 'ZohoPortalAuth', '1.0.5'
  ##  pod 'IAM_ClientUsers', :path => ''
  #  pod 'Apptics-SDK/Core', '1.0.0'
  #   pod 'Apptics-SDK/CrashKit', '1.0.0'
  #   pod 'Apptics-SDK/Scripts', '1.0.0'
  #   pod 'AppticsRateUs', '1.0.0'
  #   pod 'AppticsFeedbackKit', '1.0.0'
#  s.vendored_frameworks =  'Example/Pods/ZohoPortalAuth/ZohoPortalAuthKit.framework'
end