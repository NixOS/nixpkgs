{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pkgconfig
, libxml2, nettle
, withGTK3 ? true, gtk3 }:

stdenv.mkDerivation rec {
  pname = "stoken";
  version = "0.90";
  name = "${pname}-${version}";
  src = fetchFromGitHub {
    owner = "cernekee";
    repo = pname;
    rev = "v${version}";
    sha256 = "1k7wn8pmp7dv646g938dsr99090lsphl7zy4m9x7qbh2zlnnf9af";
  };

  preConfigure = ''
    aclocal
    libtoolize --automake --copy
    autoheader
    automake --add-missing --copy
    autoconf
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    autoconf automake libtool
    libxml2 nettle
  ] ++ stdenv.lib.optional withGTK3 gtk3;

  meta = with stdenv.lib; {
    description = "Software Token for Linux/UNIX";
    homepage = https://github.com/cernekee/stoken;
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.fuuzetsu ];
    platforms = platforms.all;
  };
}
