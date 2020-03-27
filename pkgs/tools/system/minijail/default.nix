{ stdenv, fetchFromGitiles, libcap }:

stdenv.mkDerivation rec {
  pname = "minijail";
  version = "14";

  src = fetchFromGitiles {
    url = "https://android.googlesource.com/platform/external/minijail";
    rev = "linux-v${version}";
    sha256 = "00dq854n4zg3ca2b46f90k15n32zn2sgabi76mnq2w985k9v977n";
  };

  buildInputs = [ libcap ];

  makeFlags = [ "LIBDIR=$(out)/lib" ];

  preConfigure = ''
    substituteInPlace common.mk --replace /bin/echo echo
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
    maintainers = with stdenv.lib.maintainers; [ pcarrier qyliss ];
    platforms = stdenv.lib.platforms.linux;
  };
}
