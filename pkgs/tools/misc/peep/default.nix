{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "peep";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "ryochack";
    repo = "peep";
    rev = "55c13d3672cf0002105c04decdd180e9189f1a1c";
    sha256 = "sha256-6Y7ZI0kIPE7uMMOkXgm75JMEec090xZPBJFJr9DaswA=";
  };

  cargoSha256 = "sha256-CDWa03H8vWfhx2dwZU5rAV3fSwAGqCIPcvl+lTG4npE=";

  meta = with lib; {
    description = "The CLI text viewer tool that works like less command on small pane within the terminal window";
    license = licenses.mit;
    homepage = "https://github.com/ryochack/peep";
    maintainers = with maintainers; [ ];
  };
}
