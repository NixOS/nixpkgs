{ stdenv, lib, rustPlatform, fetchFromGitHub, ncurses, CoreServices }:
let version = "0.2.5"; in
rustPlatform.buildRustPackage {
  pname = "dijo";
  inherit version;
  buildInputs = [ ncurses ] ++ lib.optional stdenv.isDarwin CoreServices;
  src = fetchFromGitHub {
    owner = "NerdyPepper";
    repo = "dijo";
    rev = "v${version}";
    sha256 = "sha256-DdK9qdF+rFtAhemPwMpiZrtUdgD0iFqjgiZ3Yp/vLAI=";
  };
  cargoSha256 = "sha256-bdSXyxiHwGtdyce2YyPKq+3RfZIL425RvwRfKi59RVI=";

  meta = with lib; {
    description = "Scriptable, curses-based, digital habit tracker";
    homepage = "https://github.com/NerdyPepper/dijo";
    license = licenses.mit;
    maintainers = with maintainers; [ infinisil ];
  };
}
