{ lib, ruby, buildRubyGem }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "brakeman";
  version = "4.8.0";
  source.sha256 = "0xy28pq4x1i7xns5af9k8fx35sqffz2lg94fgbsi9zhi877b7srg";

  meta = with lib; {
    description = "Static analysis security scanner for Ruby on Rails";
    homepage = "https://brakemanscanner.org/";
    changelog = "https://github.com/presidentbeef/brakeman/releases/tag/v${version}";
    license = [ licenses.unfreeRedistributable ];
    platforms = ruby.meta.platforms;
    maintainers = [ maintainers.marsam ];
  };
}
