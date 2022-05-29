{ stdenv
, runCommand
, makeBinaryWrapper
, binutils
, expectedArch ? stdenv.hostPlatform.parsed.cpu.name
}:

runCommand "make-binary-wrapper-test-cross" {
  nativeBuildInputs = [
    makeBinaryWrapper
    binutils
  ];
  inherit expectedArch;
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
