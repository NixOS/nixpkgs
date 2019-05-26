{ stdenv, fetchgit, libcap }:

stdenv.mkDerivation rec {
  shortname = "minijail";
  name = "${shortname}-${version}";
  version = "android-9.0.0_r3";

  src = fetchgit {
    url = "https://android.googlesource.com/platform/external/minijail";
    rev = version;
    sha256 = "1g1g52s3q61amcnx8cv1332sbixpck1bmjzgsrjiw5ix7chrzkp2";
  };

  buildInputs = [ libcap ];

  makeFlags = [ "LIBDIR=$(out)/lib" ];

  preConfigure = ''
    substituteInPlace common.mk --replace /bin/echo echo
    sed -i '/#include <asm\/siginfo.h>/ d' signal_handler.c
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp -v *.so $out/lib
    mkdir -p $out/include
    cp -v libminijail.h $out/include
    mkdir -p $out/bin
    cp minijail0 $out/bin
  '';

  meta = {
    homepage = https://android.googlesource.com/platform/external/minijail/;
    description = "Sandboxing library and application using Linux namespaces and capabilities";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [pcarrier];
    platforms = stdenv.lib.platforms.linux;
  };
}
