{ lib, stdenv, fetchFromGitHub
, withPlatform ? "generic"
, withPayload ? null
, withFDT ? null
}:

stdenv.mkDerivation rec {
  pname = "opensbi";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = "opensbi";
    rev = "v${version}";
    sha256 = "sha256-k6f4/lWY/f7qqk0AFY4tdEi4cDilSv/jngaJYhKFlnY=";
  };

  postPatch = ''
    patchShebangs ./scripts
  '';

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
