{ lib
, stdenv
, fetchFromGitHub
, python3
, withPlatform ? "generic"
, withPayload ? null
, withFDT ? null
}:

stdenv.mkDerivation rec {
  pname = "opensbi";
<<<<<<< HEAD
  version = "1.3.1";
=======
  version = "1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = "opensbi";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-JNkPvmKYd5xbGB2lsZKWrpI6rBIckWbkLYu98bw7+QY=";
=======
    sha256 = "sha256-Zcl+SE2nySMycV/ozsl4AvGipRsMblA5mt3oVZ81Z44=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    patchShebangs ./scripts
  '';

  nativeBuildInputs = [ python3 ];

  installFlags = [
    "I=$(out)"
  ];

  makeFlags = [
    "PLATFORM=${withPlatform}"
  ] ++ lib.optionals (withPayload != null) [
    "FW_PAYLOAD_PATH=${withPayload}"
  ] ++ lib.optionals (withFDT != null) [
    "FW_FDT_PATH=${withFDT}"
  ];

  dontStrip = true;
  dontPatchELF = true;

  meta = with lib; {
    description = "RISC-V Open Source Supervisor Binary Interface";
    homepage = "https://github.com/riscv-software-src/opensbi";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ius nickcao zhaofengli ];
    platforms = [ "riscv64-linux" ];
  };
}
