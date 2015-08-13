{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pkgconfig
, libxml2, nettle
, withGTK3 ? true, gtk3 }:

stdenv.mkDerivation rec {
  pname = "stoken";
  version = "v0.90";
  name = "${pname}-${version}";
  src = fetchFromGitHub {
    owner = "cernekee";
    repo = pname;
    rev = version;
    sha256 = "1k7wn8pmp7dv646g938dsr99090lsphl7zy4m9x7qbh2zlnnf9af";
  };

  preConfigure = ''
    aclocal
    libtoolize --automake --copy
    autoheader
    automake --add-missing --copy
    autoconf
  '';
  buildInputs = [
    autoconf automake libtool pkgconfig
    libxml2 nettle
  ] ++ (if withGTK3 then [ gtk3 ] else []);

  meta = {
    description = "Software Token for Linux/UNIX";
    homepage = https://github.com/cernekee/stoken;
    license = stdenv.lib.license.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.fuuzetsu ];
    platforms = stdenv.lib.platforms.all;
  };
}
