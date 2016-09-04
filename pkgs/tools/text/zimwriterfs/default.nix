{ stdenv, fetchgit, automake, autoconf, libtool, lzma, pkgconfig, zimlib, file, zlib }:

stdenv.mkDerivation {
  name = "zimwriterfs";
  version = "20150710";

  src = fetchgit {
    url = https://gerrit.wikimedia.org/r/p/openzim.git;
    rev = "165eab3e154c60b5b6436d653dc7c90f56cf7456";
    sha256 = "076ixsq4lis0rkk7p049g02bidc7bggl9kf2wzmgmsnx396mqymf";
  };

  buildInputs = [ automake autoconf libtool lzma pkgconfig zimlib file zlib ];
  setSourceRoot = "cd openzim-*/zimwriterfs; export sourceRoot=`pwd`";
  preConfigurePhases = [ "./autogen.sh" ];

  meta = {
    description = "A console tool to create ZIM files";
    homepage = http://git.wikimedia.org/log/openzim;
    maintainers = with stdenv.lib.maintainers; [ robbinch ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
