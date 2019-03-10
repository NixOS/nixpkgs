{ stdenv, fetchurl, pkgconfig, python3, sqlite, libedit, zlib }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "5.6.0";
  pname = "link-grammar";

  outputs = [ "bin" "out" "dev" "man" ];

  src = fetchurl {
    url = "http://www.abisource.com/downloads/${pname}/${version}/${name}.tar.gz";
    sha256 = "0v4hn72npjlcf5aaw3kqmvf05vf15mp2r1s2nbj5ggxpprjj6dsm";
  };

  nativeBuildInputs = [ pkgconfig python3 ];
  buildInputs = [ sqlite libedit zlib ];

  configureFlags = [
    "--disable-java-bindings"
  ];

  meta = with stdenv.lib; {
    description = "A Grammar Checking library";
    homepage = https://www.abisource.com/projects/link-grammar/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
