{ stdenv, fetchgit, fetchurl, automake, autoconf, libtool
, zlib, openssl, zip, zimlib
}:

let
  cxxtools = stdenv.mkDerivation rec {
    name = "cxxtools-${version}";
    version = "2.1.1";
    src = fetchurl {
      url = "http://www.tntnet.org/download/cxxtools-${version}.tar.gz";
      sha256 = "0jh5wrk9mviz4xrp1wv617gwgl4b5mc21h21wr2688kjmc0i1q4d";
    };
  };
  tntnet = stdenv.mkDerivation rec {
    name = "tntnet-${version}";
    version = "2.1";
    src = fetchurl {
      url = "http://www.tntnet.org/download/tntnet-${version}.tar.gz";
      sha256 = "1dhs10yhpmdqyykyh8jc67m5xgsgm1wrpd58fdps2cp5g1gjf8w6";
    };
    buildInputs = [ zlib cxxtools openssl zip ];
  };

in stdenv.mkDerivation rec {
  name = "zimreader-${version}";
  version = "20150710";

  src = fetchgit {
    url = https://gerrit.wikimedia.org/r/p/openzim.git;
    rev = "165eab3e154c60b5b6436d653dc7c90f56cf7456";
    sha256 = "076ixsq4lis0rkk7p049g02bidc7bggl9kf2wzmgmsnx396mqymf";
  };

  buildInputs = [ automake autoconf libtool zimlib cxxtools tntnet ];
  setSourceRoot = "cd openzim-*/zimreader; export sourceRoot=`pwd`";
  preConfigurePhases = [ "./autogen.sh" ];

  meta = {
    description = "A tool to serve ZIM files using HTTP";
    homepage = http://git.wikimedia.org/log/openzim;
    maintainers = with stdenv.lib.maintainers; [ robbinch ];
    platforms = [ "x86_64-linux" ];
  };
}
