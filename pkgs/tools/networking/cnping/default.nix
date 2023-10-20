{ lib, stdenv, fetchFromGitHub, libglvnd, xorg }:

stdenv.mkDerivation rec {
  pname = "cnping";
  version = "unstable-2023-01-26";

  src = fetchFromGitHub {
    owner = "cntools";
    repo = "cnping";
    rev = "16ee54ac8a6630a778aa1d1354c4303a70ca56eb";
    sha256 = "sha256-AR96vww1LP1hJ1L3U8+Wtkc4GYYA88SIKcWhu+CWv+A=";
    fetchSubmodules = true;
  };

  buildInputs = [ libglvnd xorg.libXinerama xorg.libXext xorg.libX11 ];

  # The "linuxinstall" target won't work for us:
  # it tries to setcap and copy to a FHS directory
  installPhase = ''
    mkdir -p $out/{bin,share/man/man1}
    cp cnping $out/bin/cnping
    cp cnping.1 $out/share/man/man1/cnping.1
  '';

  meta = with lib; {
    description = "Minimal Graphical IPV4 Ping Tool";
    homepage = "https://github.com/cntools/cnping";
    license = with licenses; [ mit bsd3 ]; # dual licensed, MIT-x11 & BSD-3-Clause
    maintainers = with maintainers; [ ckie ];
    platforms = platforms.linux;
  };
}
