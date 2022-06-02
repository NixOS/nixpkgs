{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "eva";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nerdypepper";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-INXKjjHW9HZ1NWx1CQOerTBUy0rYFLNJMuRgKQfQwdc=";
  };

  cargoSha256 = "sha256-4l9y2qmS7G1PvxF8/51F7fx/sDuYHWDkcyOin2sYHdk=";

  meta = with lib; {
    description = "A calculator REPL, similar to bc";
    homepage = "https://github.com/NerdyPepper/eva";
    license = licenses.mit;
    maintainers = with maintainers; [ nrdxp ma27 ];
  };
}
