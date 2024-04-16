{ lib
, stdenv
, fetchFromGitHub
, qmk
}:

# Ensure toolchains are capable of compiling for QMK platforms
# Use handwired/onekey/*:default as a proxy for each MCU platform supported by QMK

stdenv.mkDerivation (finalAttrs: {
  pname = "qmk-firmware-smoke-test";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "qmk";
    repo = "qmk_firmware";
    rev = finalAttrs.version;
    hash = "sha256-qIC87D2YdI2TV5rDRc22a3M7sJMP+qs4QFMHhJXGs2M=";
    fetchSubmodules = true;
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ qmk ];

  buildPhase = ''
    runHook preBuild

    qmkKeyboards=$(find keyboards/handwired/onekey -name 'info.json' | sed 's|keyboards/\(.*\)/info.json|\1:default|')

    # RISC-V cross with picolibc not currently supported in nixpkgs
    qmkDisableKeyboards=( "handwired/onekey/sipeed_longan_nano:default" )

    for del in ''${qmkDisableKeyboards[@]}
    do
      qmkKeyboards=("''${qmkKeyboards[@]/$del}")
    done
    echo "building qmk keyboards"
    echo "$qmkKeyboards"

    export MAKEFLAGS="SKIP_VERSION=1"
    qmk mass-compile -j ''${NIX_BUILD_CORES:-0} $qmkKeyboards || touch .failed
    # Generate the step summary markdown
    ./util/ci/generate_failure_markdown.sh || true
    # Exit with failure if the compilation stage failed
    [ ! -f .failed ] || exit 1

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/qmk_firmware/firmware
    find . \( \
      -name '*.bin' \
      -or -name '*.hex' \
      -or -name '*.uf2' \
      -or -name 'failed.*' \) \
      -exec install -m444 {} $out/share/qmk_firmware/firmware/ \;

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open-source keyboard firmware for Atmel AVR and Arm USB families";
    homepage = "https://qmk.fm";
    license = with licenses; [ gpl2Only gpl3Only bsd3 ];
    platforms = platforms.unix;
    inherit (qmk.meta) maintainers;
  };
})
