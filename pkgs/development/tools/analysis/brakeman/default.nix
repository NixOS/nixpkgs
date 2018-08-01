{ lib, ruby, buildRubyGem }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "brakeman";
  version = "4.3.1";
  source.sha256 = "1y4i4vw7hawypvgg04s544fqx52ml67h9zxsaqm8w5hvxmb20wkh";

  meta = with lib; {
    description = "Static analysis security scanner for Ruby on Rails";
    homepage = https://brakemanscanner.org/;
    license = [ licenses.cc-by-nc-sa-40 licenses.mit ];
    platforms = ruby.meta.platforms;
    maintainers = [ maintainers.marsam ];
  };
}
