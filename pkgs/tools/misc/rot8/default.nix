{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "rot8";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "efernau";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-i+VLVA/XKZiFPEeFHR3CpZKi8CWA/tiaZJerciqQHJ0=";
  };

  cargoHash = "sha256-Zz3RK79pMBn9JcpOVHf8vrvQzOJuV7anm136HcTBhJE=";

  meta = with lib; {
    description = "screen rotation daemon for X11 and sway";
    homepage = "https://github.com/efernau/rot8";
    license = licenses.mit;
    maintainers = [ maintainers.smona ];
    mainProgram = pname;
    platforms = platforms.linux;
  };
}
