{ lib, ruby, buildRubyGem }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "brakeman";
  version = "4.5.0";
  source.sha256 = "0c11i01yw87fssmwbybaqf5rdxsjp44hvxdw54c3iqb8fvj76b68";

  meta = with lib; {
    description = "Static analysis security scanner for Ruby on Rails";
    homepage = https://brakemanscanner.org/;
    license = [ licenses.cc-by-nc-sa-40 licenses.mit ];
    platforms = ruby.meta.platforms;
    maintainers = [ maintainers.marsam ];
  };
}
