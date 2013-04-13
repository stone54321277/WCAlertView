Pod::Spec.new do |s|
  s.name         = "WCAlertView"
  s.version      = "2.0.0"
  s.summary      = "A highly customizable subclass of UIAlertView."
  s.homepage     = "https://github.com/jessesquires/WCAlertView"
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author       = { "Jesse Squires" => "jesse.d.squires@gmail.com" , "Michał Zaborowski" => "m1entus@gmail.com" }
  s.source       = { :git => "https://github.com/jessesquires/WCAlertView.git", :tag => '2.0.0' }
  s.source_files = 'WCAlertView/*.{h,m}'
  s.platform     = :ios, '6.0'
  s.framework  = 'CoreGraphics'
  s.requires_arc = true
end
