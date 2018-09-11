Pod::Spec.new do |s|

  s.name         = "PonyImagePicker"
  s.version      = "0.0.1"
  s.summary      = "Similar to UIImagePicker and supports multiple selection."

  s.description  = <<-DESC
                   Similar to UIImagePicker and supports multiple selection.
                   DESC

  s.homepage     = "http://EXAMPLE/PonyImagePicker"

  s.license      = "MIT"
  
  s.author             = { "PonyCui" => "cuis@vip.qq.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/PonyCui/PonyImagePicker.git", :tag => "#{s.version}" }

  s.source_files  = "Source", "Source/**/*.{h,m}" 

  s.framework  = "Photos"
  s.requires_arc = true

end
