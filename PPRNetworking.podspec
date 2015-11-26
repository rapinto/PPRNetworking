#
#  Be sure to run `pod spec lint PPRNetworking.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "PPRNetworking"
  s.version      = "3.0.2"
  s.summary      = "OAuth1 AFNetworking overlay that add request cancelling methods and operation delegates"

  s.description  = <<-DESC
                   A longer description of PPRNetworking in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/rapinto/PPRNetworking"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "rpinto" => "" }
  # Or just: s.author    = "rpinto"
  # s.authors            = { "rpinto" => "" }
  s.social_media_url   = "http://twitter.com/rpinto"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

    s.watchos.deployment_target = '2.0'
    s.ios.deployment_target = '7.0'


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

    s.source = { :git => "https://github.com/rapinto/PPRNetworking.git", :tag => s.version, :submodules => true }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.public_header_files = 'Classes/PPRNetworking.h'
    s.source_files = 'Classes/PPRNetworking.h'


  # ――― Sub Specs ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    s.subspec 'SessionManager' do |ss|
        ss.source_files = 'Classes/PPRHTTPSessionManager.{h,m}'
        ss.public_header_files = 'Classes/PPRHTTPSessionManager.h'
        ss.dependency 'PPRNetworking/ManagerDelegate'
    end

    s.subspec 'ManagerDelegate' do |ss|
        ss.source_files = 'Classes/PPRHTTPManagerDelegate.h'
        ss.public_header_files = 'Classes/PPRHTTPManagerDelegate.h'
    end


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

    s.requires_arc = true

    s.dependency 'AFNetworking', '3.0.0-beta.2'

end
