{ lib, ruby, buildRubyGem }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "brakeman";
  version = "5.0.0";
  source.sha256 = "0k1ynqsr9b0vnxqb7d5hbdk4q1i98zjzdnx4y1ylikz4rmkizf91";

  meta = with lib; {
    description = "Static analysis security scanner for Ruby on Rails";
    homepage = "https://brakemanscanner.org/";
    changelog = "https://github.com/presidentbeef/brakeman/blob/v${version}/CHANGES.md";
    license = [ licenses.unfreeRedistributable ];
    platforms = ruby.meta.platforms;
    maintainers = [ maintainers.marsam ];
  };
}
