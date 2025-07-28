{
  stdenv,
  lib,
  fetchFromGitiles,
  libcap,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "minijail";
  version = "2025.07.02";

  src = fetchFromGitiles {
    url = "https://chromium.googlesource.com/chromiumos/platform/minijail";
    rev = "linux-v${version}";
    sha256 = "sha256-GRnr2O6ZpWtRDGJ6Am0XPT426Xh7wxTJsoEqyTUECYY=";
  };

  buildInputs = [ libcap ];

  nativeBuildInputs = [ installShellFiles ];

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

    installManPage minijail0.1 minijail0.5
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
