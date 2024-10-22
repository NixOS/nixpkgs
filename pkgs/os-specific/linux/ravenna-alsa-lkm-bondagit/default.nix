{ lib
, stdenv
, fetchFromGitHub
, kernel
}:

stdenv.mkDerivation rec {
  name = "ravenna-alsa-lkm_${version}_${kernel.version}";

  version = "1.10";

  src = fetchFromGitHub {
    owner = "bondagit";
    repo = "ravenna-alsa-lkm";
    rev = "b7bed58ce7f5f722f36e0ce6f3b7f79540323699";
    sha256 = "sha256-GnOyaT011iaSpxe4T9xTigHrTgc1f3DQF1RasItkTb8=";
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
