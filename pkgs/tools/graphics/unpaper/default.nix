{ stdenv, fetchurl, pkgconfig, libav, libxslt }:

stdenv.mkDerivation rec {
  name = "unpaper-${version}";
  version = "6.1";

  src = fetchurl {
    url = "https://www.flameeyes.eu/files/${name}.tar.xz";
    sha256 = "0c5rbkxbmy9k8vxjh4cv0bgnqd3wqc99yzw215vkyjslvbsq8z13";
  };

  buildInputs = [ pkgconfig libav libxslt ];

  meta = with stdenv.lib; {
    homepage = https://www.flameeyes.eu/projects/unpaper;
    description = "Post-processing tool for scanned sheets of paper";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
