{ stdenv, fetchurl, bison, flex, libsepol }:

stdenv.mkDerivation rec {
  name = "checkpolicy-${version}";
  version = "2.4";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/checkpolicy-${version}.tar.gz";
    sha256 = "1m5wjm43lzp6bld8higsvdm2dkddydihhwv9qw2w9r4dm0largcv";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ libsepol ];

  NIX_CFLAGS_COMPILE = "-fstack-protector-all";

  # Don't build tests
  postPatch = ''
    sed -i '/-C test/d' Makefile
  '';

  preBuild = ''
    makeFlagsArray+=("LEX=flex")
    makeFlagsArray+=("LIBDIR=${libsepol}/lib")
    makeFlagsArray+=("PREFIX=$out")
  '';

  meta = libsepol.meta // {
    description = "SELinux policy compiler";
  };
}
