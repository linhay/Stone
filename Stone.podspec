Pod::Spec.new do |s|
    s.name             = 'Stone'
    s.version          = '0.0.1'
    s.summary          = 'A short description of Stone.'

    s.description      = <<-DESC
    TODO: Add long description of the pod here.
    DESC

    s.homepage         = 'https://github.com/linhay/Stone'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'linhey' => '158179948@qq.com' }
    s.source           = { :git => 'https://github.com/linhay/Stone.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

    s.swift_versions = ['4.0', '4.2', '5.0']

    s.requires_arc = true
    s.ios.deployment_target = '8.0'
    s.tvos.deployment_target = '9.0'
    s.osx.deployment_target = '10.10'
    s.watchos.deployment_target = '2.0'
    s.source_files = ['Sources/Stone/**/*','Sources/custom/**/**/*']

end
