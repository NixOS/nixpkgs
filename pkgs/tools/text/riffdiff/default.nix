{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "2.23.3";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = version;
    hash = "sha256-5C2Q9moFo39zeLK0PkY6S74I/MI8TVpD3tRAaX4TMT4=";
  };

  cargoHash = "sha256-xHdlU9YXvEvfspDntLLgWr/knAfjMmiWK9JCV9wtIIE=";

  meta = with lib; {
    description = "A diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    license = licenses.mit;
    maintainers = with maintainers; [ johnpyp ];
    mainProgram = "riff";
  };
}
