{stdenv, fetchurl, tcl, tk, xproto, libX11}:

stdenv.mkDerivation {
  name = "expect-5.44.1";

  src = fetchurl {
    url = http://expect.nist.gov/old/expect-5.44.1.tar.gz;
    sha256 = "13zxqiclzk1paxc0mr2vwp9nhfyr2mkwk9gs73fg0l3iss16n6p4";
  };

  buildInputs = [tcl tk xproto libX11];

  #NIX_CFLAGS_COMPILE = "-DHAVE_UNISTD_H";

  # http://wiki.linuxfromscratch.org/lfs/ticket/2126
  #preBuild = ''
  #  substituteInPlace exp_inter.c --replace tcl.h tclInt.h
  #'';

  patchPhase = ''
    substituteInPlace configure --replace /bin/stty "$(type -tP stty)"
    sed -e '1i\#include <tclInt.h>' -i exp_inter.c
    export NIX_LDFLAGS="-rpath $out/lib $NIX_LDFLAGS"
  '';

  configureFlags = ["--with-tcl=${tcl}/lib"
    "--with-tclinclude=${tcl}/include"
    "--with-tk=${tk}/lib"
    "--exec-prefix=$out"];

  meta = {
    description = "A tool for automating interactive applications";
    homepage = http://expect.nist.gov/;
  };
  postInstall="cp expect{,k} $out/bin; mkdir -p $out/lib; cp *.so $out/lib";
}
