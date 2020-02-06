{ stdenv, fetchurl, python3, pkgconfig, vala, glib, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "xmlbird";
  version = "1.2.11";

  src = fetchurl {
    url = "https://birdfont.org/${pname}-releases/lib${pname}-${version}.tar.xz";
    sha256 = "1ycbgjvywnlc0garw8qjqd18s0xnrwjvssdrb410yschv3wjq1i0";
  };

  nativeBuildInputs = [ python3 pkgconfig vala gobject-introspection ];

  buildInputs = [ glib ];

  postPatch = "patchShebangs .";

  buildPhase = "./build.py";

  installPhase = "./install.py";

  meta = with stdenv.lib; {
    description = "XML parser for Vala and C programs";
    homepage = https://birdfont.org/xmlbird.php;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
