{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  name = "iotop-0.6";

  src = fetchurl {
    url = "http://guichaz.free.fr/iotop/files/${name}.tar.bz2";
    sha256 = "0nzprs6zqax0cwq8h7hnszdl3d2m4c2d4vjfxfxbnjfs9sia5pis";
  };

  doCheck = false;

  meta = {
    description = "A tool to find out the processes doing the most IO";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
