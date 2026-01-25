{
  lib,
  stdenv,
  fetchurl,

  auto-patchelf,
  dpkg,
  freetype,
  jq,
}:

stdenv.mkDerivation {
  name = "auto-patchelf-structured-log-test";

  src = fetchurl {
    url = "https://tonelib.net/download/221222/ToneLib-Jam-amd64.deb";
    sha256 = "sha256-c6At2lRPngQPpE7O+VY/Hsfw+QfIb3COIuHfbqqIEuM=";
  };

  unpackCmd = ''
    dpkg -x $curSrc source
  '';

  nativeBuildInputs = [
    dpkg
    auto-patchelf
    jq
  ];

  installPhase = ''
    auto-patchelf \
      --paths ./usr/bin/ToneLib-Jam \
      --libs ${lib.getLib freetype}/lib \
      --structured-logs > log.jsonl || true

    # Expect 1 SetInterpreter line
    jq -e -s '[.[] | select(has("SetInterpreter"))] | length == 1' log.jsonl

    # We expect 3 Dependency lines
    jq -e -s '[.[] | select(has("Dependency"))] | length == 3' log.jsonl

    # Expect the last line to set the rpath as expected
    jq -e -s 'last == {
      "SetRpath": {
        "file": "usr/bin/ToneLib-Jam",
        "rpath": "${lib.getLib freetype}/lib"
      }
    }' log.jsonl

    cp log.jsonl $out
  '';

}
