{ lib
, stdenv
, fetchFromGitHub
, kernel
}:

stdenv.mkDerivation rec {
  name = "ravenna-alsa-lkm_${version}_${kernel.version}";

  version = "unstable-2023-07-16";

  src = fetchFromGitHub {
    owner = "bondagit";
    repo = "ravenna-alsa-lkm";
    rev = "6ca0a3d12fbdb91544c0ebde45d368c1fcd97270";
    sha256 = "sha256-bCa5QSxL5YqIlpL7YfJokJN+fBBaQg3p+KwpqK8A1RM=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  enableParallelBuilding = true;

  configurePhase = ''
    cd driver
    substituteInPlace ./Makefile --replace "/lib/modules" "${kernel.dev}/lib/modules"
  '';

  installPhase = ''
    runHook preInstall
    install --verbose --mode=644 -D --target-directory="$out/lib/modules/${kernel.modDirVersion}/kernel/sound/drivers/ravenna" MergingRavennaALSA.ko
    runHook postInstall
  '';

  meta = {
    description = "Merging Technologies' ALSA driver implementation of Ravenna and AES67, with additional work by bondagit";
    homepage = "https://github.com/bondagit/ravenna-alsa-lkm";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.mrobbetts ];
  };
}
