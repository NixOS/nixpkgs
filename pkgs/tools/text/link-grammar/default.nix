{ stdenv, fetchurl, pkgconfig, python3, sqlite, libedit, zlib }:

stdenv.mkDerivation rec {
  version = "5.8.0";
  pname = "link-grammar";

  outputs = [ "bin" "out" "dev" "man" ];

  src = fetchurl {
    url = "http://www.abisource.com/downloads/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "1v8ngx77nachxln68xpvyw2lh7z59pzsi99h8j0mnrm0gjsacrdd";
  };

  nativeBuildInputs = [ pkgconfig python3 ];
  buildInputs = [ sqlite libedit zlib ];

  configureFlags = [
    "--disable-java-bindings"
  ];

  meta = with stdenv.lib; {
    description = "A Grammar Checking library";
    homepage = "https://www.abisource.com/projects/link-grammar/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
