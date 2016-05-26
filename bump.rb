#!/usr/bin/env ruby
require 'rubygems'
require 'semantic'
require 'YAML'

podspec = File.open("AFMInfoBanner.podspec", "r"){ |file| file.read }

version = /"[0-9.]{1,}"/.match(podspec).to_s.gsub!(/"/, '')
version = Semantic::Version.new version
version.patch += 1

podspec.gsub! /"[0-9.]{1,}"/, "\"#{version.to_s}\""

File.open('AFMInfoBanner.podspec', 'w') { |file| file.write podspec }

system("git config --global push.default current")
system("git tag #{version} -f")
system("git commit -am\"Bump to #{version.to_s} \"")
system("git push --force --tags")
system("pod repo update")
system("pod repo push eharmony-podspec-repo --use-libraries --verbose --allow-warnings")

print("Updated to version #{version.to_s} successfully. \n")
