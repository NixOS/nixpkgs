{ lib, stdenv, fetchurl, pkg-config, python3, sqlite, libedit, zlib }:

stdenv.mkDerivation rec {
  version = "5.8.1";
  pname = "link-grammar";

  outputs = [ "bin" "out" "dev" "man" ];

  src = fetchurl {
    url = "http://www.abisource.com/downloads/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-EcT/VR+lFpJX2sxXUIDGOwdceQ7awpmEqUZBoJk7UFs=";
  };

  nativeBuildInputs = [ pkg-config python3 ];
  buildInputs = [ sqlite libedit zlib ];

  configureFlags = [
    "--disable-java-bindings"
  ];

  meta = with lib; {
    description = "A Grammar Checking library";
    homepage = "https://www.abisource.com/projects/link-grammar/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
