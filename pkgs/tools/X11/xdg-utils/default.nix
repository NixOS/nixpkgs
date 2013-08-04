{ stdenv, fetchurl, file }:

stdenv.mkDerivation rec {
  name = "xdg-utils-1.1.0-rc1";
  
  src = fetchurl {
    url = "http://portland.freedesktop.org/download/${name}.tar.gz";
    sha256 = "00lisw4x43sp189lb7dz46j2l09y5v2fijk3d0sxx3mvwj55a1bv";
  };

  postInstall = ''
    substituteInPlace $out/bin/xdg-mime --replace /usr/bin/file ${file}/bin/file
  '';
  
  meta = {
    homepage = http://portland.freedesktop.org/wiki/;
    description = "A set of command line tools that assist applications with a variety of desktop integration tasks";
    license = "free";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
