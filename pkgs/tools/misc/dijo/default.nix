{ stdenv, lib, rustPlatform, fetchFromGitHub, ncurses, CoreServices }:
let version = "0.1.5"; in
rustPlatform.buildRustPackage {
  pname = "dijo";
  inherit version;
  buildInputs = [ ncurses ] ++ lib.optional stdenv.isDarwin CoreServices;
  src = fetchFromGitHub {
    owner = "NerdyPepper";
    repo = "dijo";
    rev = "v${version}";
    sha256 = "1ch320j2d66zn9mbs7xl0bkfcm2hpak6izk0yspz1gcji1l7grsc";
  };
  cargoSha256 = "1p6apz3wd4gqp0z24ygfw8nmpkh44d000jp6x7svqzmpphnmb0ji";

  meta = with lib; {
    description = "Scriptable, curses-based, digital habit tracker.";
    homepage = "https://github.com/NerdyPepper/dijo";
    license = licenses.mit;
    maintainers = with maintainers; [ infinisil ];
    platforms = platforms.all;
  };
}
