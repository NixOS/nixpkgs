{ stdenv, fetchurl, tcl }:

let version = "5.45";
in
stdenv.mkDerivation {
  name = "expect-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/expect/Expect/${version}/expect${version}.tar.gz";
    sha256 = "0h60bifxj876afz4im35rmnbnxjx4lbdqp2ja3k30fwa8a8cm3dj";
  };

  buildInputs = [ tcl ];

  #NIX_CFLAGS_COMPILE = "-DHAVE_UNISTD_H";

  # http://wiki.linuxfromscratch.org/lfs/ticket/2126
  #preBuild = ''
  #  substituteInPlace exp_inter.c --replace tcl.h tclInt.h
  #'';

  patchPhase = ''
    substituteInPlace configure --replace /bin/stty "$(type -tP stty)"
    sed -e '1i\#include <tclInt.h>' -i exp_inter.c
    export NIX_LDFLAGS="-rpath $out/lib $NIX_LDFLAGS"
  '' + stdenv.lib.optionalString stdenv.isFreeBSD ''
    ln -s libexpect.so.1 libexpect545.so
  '';

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tclinclude=${tcl}/include"
    "--exec-prefix=$out"
  ];

  postInstall = let libSuff = if stdenv.isDarwin then "dylib" else "so";
    in "cp expect $out/bin; mkdir -p $out/lib; cp *.${libSuff} $out/lib";

  meta = {
    description = "A tool for automating interactive applications";
    homepage = http://expect.nist.gov/;
  };
}
