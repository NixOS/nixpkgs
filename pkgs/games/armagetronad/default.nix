{ lib, stdenv, fetchurl
, pkg-config, SDL, libxml2, SDL_image, libjpeg, libpng, libGLU, libGL, zlib
, dedicatedServer ? false }:

let
  versionMajor = "0.2.9";
  versionMinor = "1.0";
  version = "${versionMajor}.${versionMinor}";
in
stdenv.mkDerivation {
  pname = if dedicatedServer then "armagetronad-dedicated" else "armagetronad";
  inherit version;
  src = fetchurl {
    url = "https://launchpad.net/armagetronad/${versionMajor}/${version}/+download/armagetronad-${version}.tbz";
    sha256 = "sha256-WbbHwBzj+MylQ34z+XSmN1KVQaEapPUsGlwXSZ4m9qE";
  };

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-memmanager"
    "--enable-automakedefaults"
    "--disable-useradd"
    "--disable-initscripts"
    "--disable-etc"
    "--disable-uninstall"
    "--disable-sysinstall"
  ] ++ lib.optional dedicatedServer "--enable-dedicated";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libxml2 zlib ]
    ++ lib.optionals (!dedicatedServer) [ SDL SDL_image libxml2 libjpeg libpng libGLU libGL ];

  meta = with lib; {
    homepage = "http://armagetronad.org";
    description = "A multiplayer networked arcade racing game in 3D similar to Tron";
    maintainers = with maintainers; [ numinit ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
