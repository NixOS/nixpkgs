{ lib, ruby, buildRubyGem }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "brakeman";
  version = "4.7.2";
  source.sha256 = "1j1svldxvbl27kpyp9yngfwa0fdqal926sjk0cha7h520wvnz79k";

  meta = with lib; {
    description = "Static analysis security scanner for Ruby on Rails";
    homepage = "https://brakemanscanner.org/";
    license = [ licenses.unfreeRedistributable ];
    platforms = ruby.meta.platforms;
    maintainers = [ maintainers.marsam ];
  };
}
