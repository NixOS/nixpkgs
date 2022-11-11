{ lib
, stdenv
, fetchFromGitHub
, cmake
, ruby
, xcbuild
, AVFoundation
, AudioUnit
, Cocoa
, CoreAudio
, CoreServices
, ForceFeedback
, OpenGL
}:

stdenv.mkDerivation rec {
  pname = "tic-80";
  version = "1.0.2164";

  nativeBuildInputs = [
    cmake
    ruby
  ] ++ lib.optionals stdenv.isDarwin [
    xcbuild
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    AVFoundation
    AudioUnit
    Cocoa
    CoreAudio
    CoreServices
    ForceFeedback
    OpenGL
  ];

  postInstall =
    if stdenv.isDarwin then ''
      cp -r bin $out/
    '' else "";

  src = fetchFromGitHub {
    owner = "nesbox";
    repo = "TIC-80";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "SnaAhdYoblxKlzTSyfcnvY6u7X6aIJIYWZAXtL2IIXc=";
  };

  meta = with lib; {
    description = "TIC-80 is a free and open source fantasy computer for making, playing and sharing tiny games";
    homepage = "https://tic80.com";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ davidcromp ];
  };
}
