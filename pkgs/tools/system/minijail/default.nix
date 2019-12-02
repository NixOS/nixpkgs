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

  postPatch = ''
    patchShebangs platform2_preinstall.sh
  '';

  postBuild = ''
    ./platform2_preinstall.sh ${version} $out/include/chromeos
  '';

  installPhase = ''
    mkdir -p $out/lib/pkgconfig $out/include/chromeos $out/bin
    cp -v *.so $out/lib
    cp -v *.pc $out/lib/pkgconfig
    cp -v libminijail.h scoped_minijail.h $out/include/chromeos
    cp -v minijail0 $out/bin
  '';

  meta = {
    homepage = https://android.googlesource.com/platform/external/minijail/;
    description = "Sandboxing library and application using Linux namespaces and capabilities";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [pcarrier];
    platforms = stdenv.lib.platforms.linux;
  };
}
