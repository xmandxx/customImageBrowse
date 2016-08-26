Pod::Spec.new do |s|

   s.name        = "showImage"
  s.version      = "1.0.1"
  s.summary      = "showImage."
  s.description  = <<-DESC
               full show image and zoom scale images
               DESC
  s.homepage     = "https://github.com/mynameissujie/customImageBrowse"
  s.license      = "MIT"
  s.author       = { "jeffery" => "sujie@servyou.com.cn" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/mynameissujie/customImageBrowse.git", :tag => "1.0.1" }
  s.resources = "ShowImageViews/Image/*.jpg","ShowImageViews/Image/*.png"
  s.source_files  =  "ShowImageViews/ImageBrower/*"

  s.framework  = "UIKit"
  s.requires_arc = true

end
