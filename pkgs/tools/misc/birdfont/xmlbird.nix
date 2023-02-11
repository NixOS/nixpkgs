{ lib, stdenv, fetchurl, python3, pkg-config, vala, glib, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "xmlbird";
  version = "1.2.12";

  src = fetchurl {
    url = "https://birdfont.org/${pname}-releases/lib${pname}-${version}.tar.xz";
    sha256 = "15z4rvii3p54g2hasibjnf83c1702d84367fnl8pbisjqqrdcl04";
  };

  nativeBuildInputs = [ python3 pkg-config vala gobject-introspection ];

  buildInputs = [ glib ];

  postPatch = ''
    substituteInPlace configure \
      --replace 'platform.dist()[0]' '"nix"'
    patchShebangs .
  '';

  buildPhase = "./build.py";

  installPhase = "./install.py";

  meta = with lib; {
    description = "XML parser for Vala and C programs";
    homepage = "https://birdfont.org/xmlbird.php";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
