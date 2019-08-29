{ lib, ruby, buildRubyGem }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "brakeman";
  version = "4.6.1";
  source.sha256 = "04chxflc5n6q0kz93c9dc6jwqrz0mrrlpm4iqncb39yyvg4ghcbf";

  meta = with lib; {
    description = "Static analysis security scanner for Ruby on Rails";
    homepage = https://brakemanscanner.org/;
    license = [ licenses.cc-by-nc-sa-40 licenses.mit ];
    platforms = ruby.meta.platforms;
    maintainers = [ maintainers.marsam ];
  };
}
