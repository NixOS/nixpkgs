{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "rot8";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "efernau";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-dHx3vFY0ztyTIlzUi22TYphPD5hvgfHrWaaeoGxnvW0=";
  };

  cargoHash = "sha256-KDg6Ggnm6Cl/1fXqNcc7/jRFJ6KTLVGveJ6Fs3NLlHE=";

  meta = with lib; {
    description = "screen rotation daemon for X11 and wlroots";
    homepage = "https://github.com/efernau/rot8";
    license = licenses.mit;
    maintainers = [ maintainers.smona ];
    mainProgram = pname;
    platforms = platforms.linux;
  };
}
