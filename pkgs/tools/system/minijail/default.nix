{ stdenv, lib, fetchFromGitiles, glibc, libcap, qemu }:

let
  dumpConstants =
    if stdenv.buildPlatform == stdenv.hostPlatform then "./dump_constants"
    else if stdenv.hostPlatform.isAarch32 then "qemu-arm dump_constants"
    else if stdenv.hostPlatform.isAarch64 then "qemu-aarch64 dump_constants"
    else if stdenv.hostPlatform.isx86_64 then "qemu-x86_64 dump_constants"
    else throw "Unsupported host platform";
in

stdenv.mkDerivation rec {
  pname = "minijail";
  version = "18";

  src = fetchFromGitiles {
    url = "https://android.googlesource.com/platform/external/minijail";
    rev = "linux-v${version}";
    sha256 = "sha256-OpwzISZ5iZNQvJAX7UJJ4gELEaVfcQgY9cqMM0YvBzc=";
  };

  nativeBuildInputs =
    lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) qemu;
  buildInputs = [ libcap ];

  makeFlags = [ "ECHO=echo" "LIBDIR=$(out)/lib" ];
  dumpConstantsFlags = lib.optional (stdenv.hostPlatform.libc == "glibc")
    "LDFLAGS=-L${glibc.static}/lib";

  postPatch = ''
    substituteInPlace Makefile --replace /bin/echo echo
    patchShebangs platform2_preinstall.sh
  '';

  postBuild = ''
    make $makeFlags $buildFlags $dumpConstantsFlags dump_constants
    ${dumpConstants} > constants.json
  '';

  installPhase = ''
    ./platform2_preinstall.sh ${version} $out/include/chromeos

    mkdir -p $out/lib/pkgconfig $out/include/chromeos $out/bin \
        $out/share/minijail

    cp -v *.so $out/lib
    cp -v *.pc $out/lib/pkgconfig
    cp -v libminijail.h scoped_minijail.h $out/include/chromeos
    cp -v minijail0 $out/bin
    cp -v constants.json $out/share/minijail
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://android.googlesource.com/platform/external/minijail/";
    description = "Sandboxing library and application using Linux namespaces and capabilities";
    changelog = "https://android.googlesource.com/platform/external/minijail/+/refs/tags/linux-v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pcarrier qyliss ];
    platforms = platforms.linux;
  };
}
