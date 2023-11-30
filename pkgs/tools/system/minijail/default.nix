{ stdenv, lib, fetchFromGitiles, libcap }:

stdenv.mkDerivation rec {
  pname = "minijail";
  version = "18";

  src = fetchFromGitiles {
    url = "https://android.googlesource.com/platform/external/minijail";
    rev = "linux-v${version}";
    sha256 = "sha256-OpwzISZ5iZNQvJAX7UJJ4gELEaVfcQgY9cqMM0YvBzc=";
  };

  buildInputs = [ libcap ];

  makeFlags = [ "ECHO=echo" "LIBDIR=$(out)/lib" ];

  postPatch = ''
    substituteInPlace Makefile --replace /bin/echo echo
    patchShebangs platform2_preinstall.sh
  '';

  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  installPhase = ''
    ./platform2_preinstall.sh ${version} $out/include/chromeos

    mkdir -p $out/lib/pkgconfig $out/include/chromeos $out/bin \
        $out/share/minijail

    cp -v *.so $out/lib
    cp -v *.pc $out/lib/pkgconfig
    cp -v libminijail.h scoped_minijail.h $out/include/chromeos
    cp -v minijail0 $out/bin
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://android.googlesource.com/platform/external/minijail/";
    description = "Sandboxing library and application using Linux namespaces and capabilities";
    changelog = "https://android.googlesource.com/platform/external/minijail/+/refs/tags/linux-v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pcarrier qyliss ];
    platforms = platforms.linux;
    mainProgram = "minijail0";
  };
}
