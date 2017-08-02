{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = pname + "-" + version;
  pname = "dcadec";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "foo86";
    repo = pname;
    rev = "v" + version;
    sha256 = "07nd0ajizrp1w02bsyfcv18431r8m8rq8gjfmz9wmckpg7cxj2hs";
  };

  installPhase = "make PREFIX=/ DESTDIR=$out install";

  meta = with stdenv.lib; {
    description = "DTS Coherent Acoustics decoder with support for HD extensions";
    maintainers = with maintainers; [ edwtjo ];
    homepage = https://github.com/foo86/dcadec;
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}