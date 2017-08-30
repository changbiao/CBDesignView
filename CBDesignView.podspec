#
# Be sure to run `pod lib lint CBDesignView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CBDesignView'
  s.version          = '0.2.1'
  s.summary          = 'A short description of CBDesignView.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Use IB_DESIGNABLE & IBInspectable Easy!
  添加分线程刷新UI时的断言，便于解决问题
                       DESC

  s.homepage         = 'https://github.com/changbiao/CBDesignView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'changbiao' => '5.5.5.b.i.a.o@163.com' }
  s.source           = { :git => 'https://github.com/changbiao/CBDesignView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/changbiao'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CBDesignView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CBDesignView' => ['CBDesignView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Masonry'
end
