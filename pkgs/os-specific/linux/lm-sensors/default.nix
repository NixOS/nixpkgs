{ lib
, stdenv
, fetchFromGitHub
, bash
, bison
, flex
, which
, perl
, sensord ? false
, rrdtool ? null
}:

assert sensord -> rrdtool != null;

stdenv.mkDerivation rec {
  pname = "lm-sensors";
  version = "3.6.0";
  dashedVersion = lib.replaceStrings [ "." ] [ "-" ] version;

  src = fetchFromGitHub {
    owner = "lm-sensors";
    repo = "lm-sensors";
    rev = "V${dashedVersion}";
    hash = "sha256-9lfHCcODlS7sZMjQhK0yQcCBEoGyZOChx/oM0CU37sY=";
  };

  nativeBuildInputs = [ bison flex which ];
  # bash is required for correctly replacing the shebangs in all tools for cross-compilation.
  buildInputs = [ bash perl ]
    ++ lib.optional sensord rrdtool;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "CC=${stdenv.cc.targetPrefix}cc"
    "AR=${stdenv.cc.targetPrefix}ar"
  ] ++ lib.optional sensord "PROG_EXTRA=sensord";

  installFlags = [
    "ETCDIR=${placeholder "out"}/etc"
  ];

  meta = with lib; {
    homepage = "https://hwmon.wiki.kernel.org/lm_sensors";
    changelog = "https://raw.githubusercontent.com/lm-sensors/lm-sensors/V${dashedVersion}/CHANGES";
    description = "Tools for reading hardware sensors";
    license = with licenses; [ lgpl21Plus gpl2Plus ];
    maintainers = with maintainers; [ pengmeiyu ];
    platforms = platforms.linux;
    mainProgram = "sensors";
  };
}
