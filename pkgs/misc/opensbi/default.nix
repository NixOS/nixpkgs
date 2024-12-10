{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  withPlatform ? "generic",
  withPayload ? null,
  withFDT ? null,
}:

stdenv.mkDerivation rec {
  pname = "opensbi";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "riscv-software-src";
    repo = "opensbi";
    rev = "v${version}";
    hash = "sha256-T8ZeAzjM9aeTXitjE7s+m+jjGGtDo2jK1qO5EuKiVLU=";
  };

  postPatch = ''
    patchShebangs ./scripts
  '';

  nativeBuildInputs = [ python3 ];

  installFlags = [
    "I=$(out)"
  ];

  makeFlags =
    [
      "PLATFORM=${withPlatform}"
    ]
    ++ lib.optionals (withPayload != null) [
      "FW_PAYLOAD_PATH=${withPayload}"
    ]
    ++ lib.optionals (withFDT != null) [
      "FW_FDT_PATH=${withFDT}"
    ];

  enableParallelBuilding = true;

  dontStrip = true;
  dontPatchELF = true;

  meta = with lib; {
    description = "RISC-V Open Source Supervisor Binary Interface";
    homepage = "https://github.com/riscv-software-src/opensbi";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      ius
      nickcao
      zhaofengli
    ];
    platforms = [
      "riscv64-linux"
      "riscv32-linux"
    ];
  };
}
