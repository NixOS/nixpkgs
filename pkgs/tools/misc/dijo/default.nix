{ stdenv, lib, rustPlatform, fetchFromGitHub, ncurses, CoreServices }:
let version = "0.2.2"; in
rustPlatform.buildRustPackage {
  pname = "dijo";
  inherit version;
  buildInputs = [ ncurses ] ++ lib.optional stdenv.isDarwin CoreServices;
  src = fetchFromGitHub {
    owner = "NerdyPepper";
    repo = "dijo";
    rev = "v${version}";
    sha256 = "1al2dfrfxw39m9q636h47dnypcwkhp9bw01hvy7d9b69kskb21db";
  };
  cargoSha256 = "0a2l0ynjj9wl86aawm0l0rbdkm8j3a2n0nm6ysyxamaip0q5y1ql";

  meta = with lib; {
    description = "Scriptable, curses-based, digital habit tracker.";
    homepage = "https://github.com/NerdyPepper/dijo";
    license = licenses.mit;
    maintainers = with maintainers; [ infinisil ];
    platforms = platforms.all;
  };
}
