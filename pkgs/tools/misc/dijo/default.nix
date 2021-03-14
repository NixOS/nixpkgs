{ stdenv, lib, rustPlatform, fetchFromGitHub, ncurses, CoreServices }:
let version = "0.2.6"; in
rustPlatform.buildRustPackage {
  pname = "dijo";
  inherit version;
  buildInputs = [ ncurses ] ++ lib.optional stdenv.isDarwin CoreServices;
  src = fetchFromGitHub {
    owner = "NerdyPepper";
    repo = "dijo";
    rev = "v${version}";
    sha256 = "sha256-fdPl+3NjgVE2MRopzeN/bxbVP6HaTnyJTGFWsLhlRoQ=";
  };
  cargoSha256 = "sha256-45YfZWncT7hNiOhlAatpdFdxgBaF83sih67B/DPNHcs=";

  meta = with lib; {
    description = "Scriptable, curses-based, digital habit tracker";
    homepage = "https://github.com/NerdyPepper/dijo";
    license = licenses.mit;
    maintainers = with maintainers; [ infinisil ];
  };
}
