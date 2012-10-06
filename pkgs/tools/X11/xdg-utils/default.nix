{ stdenv, fetchurl, file }:

stdenv.mkDerivation rec {
  name = "xdg-utils-1.0.2";
  
  src = fetchurl {
    url = "http://portland.freedesktop.org/download/${name}.tgz";
    sha256 = "1b019d3r1379b60p33d6z44kx589xjgga62ijz9vha95dg8vgbi1";
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
