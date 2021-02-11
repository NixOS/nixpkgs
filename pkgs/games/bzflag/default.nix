{ stdenv, lib, fetchurl, pkg-config
, curl, SDL2, libGLU, libGL, glew, ncurses, c-ares
, Carbon, CoreServices }:

stdenv.mkDerivation rec {
  pname = "bzflag";
  version = "2.4.22";

  src = fetchurl {
    url = "https://download.bzflag.org/${pname}/source/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-nmRlMwK2V72LX5b+EVCp/4Ch1Tptfoo1E4xrGwIAak0=";
  };

  patches = [ ./bzflag-2.4.20-desktop-file.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ curl SDL2 libGLU libGL glew ncurses c-ares ]
    ++ lib.optionals stdenv.isDarwin [ Carbon CoreServices ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/share/{applications,pixmaps}
    ln -st $out/share/applications $out/share/bzflag/bzflag.desktop
    ln -st $out/share/pixmaps $out/share/bzflag/bzflag-48x48.png
  '';

  meta = with lib; {
    description = "Multiplayer 3D Tank game";
    homepage = "https://bzflag.org/";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
