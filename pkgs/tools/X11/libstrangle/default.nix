{ lib, stdenv, fetchFromGitLab, libGL, libX11 }:

stdenv.mkDerivation rec {
  pname = "libstrangle";
  version = "unstable-202202022";

  buildInputs = [ libGL libX11 ];

  src = fetchFromGitLab {
    owner = "torkel104";
    repo = pname;
    rev = "0273e318e3b0cc759155db8729ad74266b74cb9b";
    sha256 = "sha256-h10QA7m7hIQHq1g/vCYuZsFR2NVbtWBB46V6OWP5wgM=";
  };

  makeFlags = [ "prefix=" "DESTDIR=$(out)" ];

  patches = [
      ./nixos.patch
  ];

  postPatch = ''
    substituteAllInPlace src/strangle.sh
    substituteAllInPlace src/stranglevk.sh
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/torkel104/libstrangle";
    description = "Frame rate limiter for Linux/OpenGL";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aske ];
    mainProgram = "strangle";
  };
}
