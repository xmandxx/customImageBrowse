Pod::Spec.new do |s|

   s.name        = "showImage"
  s.version      = "0.0.1"
  s.summary      = "showImage."
  s.description  = "full show image and zoom scale images."
  s.homepage     = "https://github.com/mynameissujie/Imagebrowse"
  s.license      = "MIT (example)"
  s.author       = { "jeffery" => "sujie@servyou.com.cn" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/mynameissujie/Imagebrowse.git", :tag => "0.0.1" }

  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.framework  = "UIKit"
  s.requires_arc = true

end
