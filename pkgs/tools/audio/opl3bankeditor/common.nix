{
  pname,
  chip,
  version,
  sha256,
  extraPatches ? [ ],
}:

{
  mkDerivation,
  stdenv,
  lib,
  fetchFromGitHub,
  dos2unix,
  cmake,
  pkg-config,
  qttools,
  qtbase,
  qwt6_1,
  rtaudio,
  rtmidi,
}:

let
  binname = "${chip} Bank Editor";
  mainProgram = "${lib.strings.toLower chip}_bank_editor";
in
mkDerivation rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "Wohlstand";
    repo = pname;
    rev = "v${version}";
    inherit sha256;
  };

  prePatch = ''
    dos2unix CMakeLists.txt
  '';

  patches = extraPatches;

  nativeBuildInputs = [
    dos2unix
    cmake
    pkg-config
    qttools
  ];

  buildInputs = [
    qtbase
    qwt6_1
    rtaudio
    rtmidi
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/{bin,Applications}
    mv "${binname}.app" $out/Applications/

    install_name_tool -change {,${qwt6_1}/lib/}libqwt.6.dylib "$out/Applications/${binname}.app/Contents/MacOS/${binname}"

    ln -s "$out/Applications/${binname}.app/Contents/MacOS/${binname}" $out/bin/${mainProgram}
  '';

  meta = with lib; {
    inherit mainProgram;
    description = "A small cross-platform editor of the ${chip} FM banks of different formats";
    homepage = src.meta.homepage;
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
