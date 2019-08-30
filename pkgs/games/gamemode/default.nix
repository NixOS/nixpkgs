{ stdenv, meson, ninja, fetchFromGitHub, systemd, pkgconfig, dbus }:

stdenv.mkDerivation rec {
  pname = "gamemode";
  version = "1.4";

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [ systemd dbus ];

  src = fetchFromGitHub {
    owner = "FeralInteractive";
    repo = "gamemode";
    rev = "7ced21f4b30cc4ceb67928889bc57af8784f1009";
    sha256 = "19s73yblbv8c7dw41sb713cjy1y6wr2srn9wvqdcsqgc159z4sj2";
    fetchSubmodules = true;
  };

  mesonFlags = "-Dwith-systemd-user-unit-dir=share/systemd/user";

  patches = [ ./gamemoderun.patch ];

  meta = with stdenv.lib; {
    description = "Optimise Linux system performance on demand";
    homepage = https://github.com/FeralInteractive/GameMode/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.leo60228 ];
  };
}
