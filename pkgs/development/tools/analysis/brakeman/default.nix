{ lib, ruby, bundlerApp, bundlerUpdateScript }:

bundlerApp rec {
  pname = "brakeman";
  exes = [ "brakeman" ];
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "brakeman";

  meta = with lib; {
    description = "Static analysis security scanner for Ruby on Rails";
    homepage = "https://brakemanscanner.org/";
    changelog = "https://github.com/presidentbeef/brakeman/blob/v${version}/CHANGES.md";
    license = [ licenses.unfreeRedistributable ];
    platforms = ruby.meta.platforms;
    maintainers = [ ];
    mainProgram = "brakeman";
  };
}
