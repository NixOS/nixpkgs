{ lib, ruby, buildRubyGem }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "brakeman";
  version = "4.7.1";
  source.sha256 = "149ny2n82hzxw4g8xnimjavs2niq14wl9kwq8zlvadavdg4g9ind";

  meta = with lib; {
    description = "Static analysis security scanner for Ruby on Rails";
    homepage = https://brakemanscanner.org/;
    license = [ licenses.cc-by-nc-sa-40 licenses.mit ];
    platforms = ruby.meta.platforms;
    maintainers = [ maintainers.marsam ];
  };
}
