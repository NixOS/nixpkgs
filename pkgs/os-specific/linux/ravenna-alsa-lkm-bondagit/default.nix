{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "ravenna-alsa-lkm_${version}_${kernel.version}";

  version = "1.14";

  src = fetchFromGitHub {
    owner = "bondagit";
    repo = "ravenna-alsa-lkm";
    rev = "7e3b67f35f7733fc7abc0bba53450ef9ca66785e";
    sha256 = "sha256-iYZLnBsNLMwNlPk9lC0UUHoGyaPwqfN8z6nAGTMfpYA=";
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
    description =
      "Merging Technologies' ALSA driver implementation of Ravenna and AES67, with additional work by bondagit";
    homepage = "https://github.com/bondagit/ravenna-alsa-lkm";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.mrobbetts ];
  };
}
