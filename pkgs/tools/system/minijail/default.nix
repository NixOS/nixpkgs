{
  stdenv,
  lib,
  fetchFromGitiles,
  libcap,
}:

stdenv.mkDerivation rec {
  pname = "minijail";
  version = "2024.05.22";

  src = fetchFromGitiles {
    url = "https://chromium.googlesource.com/chromiumos/platform/minijail";
    rev = "linux-v${version}";
    sha256 = "sha256-1NNjNEC0pNb0WW0PG5smltT1/dGYNRfhNxJtW0hngI8=";
  };

  buildInputs = [ libcap ];

  makeFlags = [
    "ECHO=echo"
    "LIBDIR=$(out)/lib"
  ];

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
    homepage = "https://chromium.googlesource.com/chromiumos/platform/minijail/+/refs/heads/main/README.md";
    description = "Sandboxing library and application using Linux namespaces and capabilities";
    changelog = "https://chromium.googlesource.com/chromiumos/platform/minijail/+/refs/tags/linux-v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      pcarrier
      qyliss
    ];
    platforms = platforms.linux;
    mainProgram = "minijail0";
  };
}
