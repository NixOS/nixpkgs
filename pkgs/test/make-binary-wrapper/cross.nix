{ stdenv
, runCommand
, makeBinaryWrapper
, binutils
, lib
, expectedArch ? stdenv.hostPlatform.parsed.cpu.name
}:


runCommand "make-binary-wrapper-test-cross" {
  nativeBuildInputs = [
    makeBinaryWrapper
    binutils
  ];
  # For x86_64-linux the machine field is
  # Advanced Micro Devices X86-64
  # and uses a dash instead of a underscore unlike x86_64-linux in hostPlatform.parsed.cpu.name
  expectedArch = lib.replaceStrings ["_"] ["-"] expectedArch;
} ''
  touch prog
  chmod +x prog
  makeWrapper prog $out
  read -r _ arch < <($READELF --file-header $out | grep Machine:)
  if [[ ''${arch,,} != *"''${expectedArch,,}"* ]]; then
    echo "expected $expectedArch, got $arch"
    exit 1
  fi
''
