Pod::Spec.new do |s|
   s.name = 'MessageKit'
   s.version = '4.0.0'
   s.license = { :type => "MIT", :file => "LICENSE.md" }

   s.summary = 'An elegant messages UI library for iOS.'
<<<<<<< HEAD
   s.homepage = 'https://github.com/HB-Krutagn/MessageKit'
   s.social_media_url = 'https://twitter.com/_SD10_'
   s.author = { "Steven Deutsch" => "stevensdeutsch@yahoo.com" }

   s.source = { :git => 'https://github.com/HB-Krutagn/MessageKit.git', :tag => s.version }
=======
   s.homepage = 'https://github.com/MessageKit/MessageKit'
   s.social_media_url = 'https://twitter.com/_SD10_'
   s.author = { "Steven Deutsch" => "stevensdeutsch@yahoo.com" }

   s.source = { :git => 'https://github.com/MessageKit/MessageKit.git', :tag => s.version }
>>>>>>> 1d059306b0f6b9ea1f91c1d35008bb4ad881dc32
   s.source_files = 'Sources/**/*.swift'

   s.swift_version = '5.5'

   s.ios.deployment_target = '12.0'
   s.ios.resources = 'Sources/Assets.xcassets'

<<<<<<< HEAD
   s.dependency 'InputBarAccessoryView', '~> 6.1.0'
=======
   s.dependency 'HBInputBarAccessoryView'
>>>>>>> 1d059306b0f6b9ea1f91c1d35008bb4ad881dc32

end
