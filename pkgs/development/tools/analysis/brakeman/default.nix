{ lib, ruby, buildRubyGem }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "brakeman";
  version = "4.5.1";
  source.sha256 = "0vqnhlswvrg5fpxszfkjmla85gdlvgspz0whlli730ydx648mi68";

  meta = with lib; {
    description = "Static analysis security scanner for Ruby on Rails";
    homepage = https://brakemanscanner.org/;
    license = [ licenses.cc-by-nc-sa-40 licenses.mit ];
    platforms = ruby.meta.platforms;
    maintainers = [ maintainers.marsam ];
  };
}
