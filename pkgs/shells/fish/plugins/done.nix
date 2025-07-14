{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  fishtape,
}:

buildFishPlugin rec {
  pname = "done";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "franciscolourenco";
    repo = "done";
    rev = version;
    hash = "sha256-WA6DBrPBuXRIloO05UBunTJ9N01d6tO1K1uqojjO0mo=";
  };

  checkPlugins = [ fishtape ];
  checkPhase = ''
    fishtape test/done.fish
  '';

  meta = with lib; {
    description = "Automatically receive notifications when long processes finish";
    homepage = "https://github.com/franciscolourenco/done";
    license = licenses.mit;
    maintainers = [ maintainers.malo ];
  };
}
