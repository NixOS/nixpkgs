{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, gtk3, epoxy, wayland }:
stdenv.mkDerivation {
  pname = "wdisplays-unstable";
  version = "2020-03-15";

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [ gtk3 epoxy wayland ];

  src = fetchFromGitHub {
    owner = "cyclopsian";
    repo = "wdisplays";
    rev = "0faafdc04d7dd47d3a4e385f348cb9d267f2e60d";
    sha256 = "1y3bzh4mi6d67n6v0i8j5snpaikpbyr89acayr4m6bx85qnrq4g2";
  };

  meta = let inherit (stdenv) lib; in {
    description = "A graphical application for configuring displays in Wayland compositors";
    homepage = "https://github.com/cyclopsian/wdisplays";
    maintainers = with lib.maintainers; [ lheckemann ma27 ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
