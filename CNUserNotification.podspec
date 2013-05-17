Pod::Spec.new do |s|
  s.name                  = 'CNUserNotification'
  s.version               = '0.0.1'
  s.summary               = 'CNUserNotification is a kind of proxy to give OS X Lion 10.7 „the same‟ support for user notifications like OS X Mountain Lion 10.8 it does.'
  s.homepage              = 'https://github.com/phranck/CNUserNotification'
  s.author                = { 'Frank Gregor' => 'phranck@cocoanaut.com' }
  s.source                = { :git => 'https://github.com/phranck/CNUserNotification.git', :tag => s.version }
  s.platform              = :osx
  s.osx.deployment_target = '10.7'
  s.requires_arc          = true
  s.source_files          = 'CNUserNotification/*.{h,m}'
  s.license               = { :type => 'MIT', :file => 'ReadMe.md' }
  s.frameworks            = 'QuartzCore'
end
