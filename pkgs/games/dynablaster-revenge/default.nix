{ stdenv
, lib
, mkDerivation
, fetchFromGitHub
, qtbase
, qmake
, wrapQtAppsHook
, libGLU
, SDL2
, alsa-lib

, isServer ? false
}:

mkDerivation rec {
  pname = "dynablaster-revenge"
    + lib.optionalString isServer "-server";
  version = "unstable-2022-04-15";

  src = fetchFromGitHub {
    owner = "varnholt";
    repo = "dynablaster_revenge";
    rev = "08fb11fb2d5dd94e1ea0e447d95cccb375dfc7e5";
    sha256 = "1apc4751l1gscbg8rlmpym2lp9dsvak8sa6s7zy10yg1h6k6c004";
  };

  postUnpack = ''
    export sourceRoot=$sourceRoot/${if isServer then "server" else "client"}
  '';

  postPatch = lib.optionalString isServer ''
    substituteInPlace server.pro \
      --replace 'TARGET = server' 'TARGET = ${meta.mainProgram}'
  '';

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ] ++ lib.optionals (!isServer) ([
    libGLU
    SDL2
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
  ]);

  installPhase = ''
    runHook preInstall

  '' + (if stdenv.isDarwin then ''
    mkdir -p $out/{Applications,bin}
    mv {,$out/Applications/}${meta.mainProgram}.app
    ln -s $out/{Applications/${meta.mainProgram}.app/Contents/MacOS,bin}/${meta.mainProgram}
  '' else ''
    install -Dm755 {,$out/bin/}${meta.mainProgram}
  '') + lib.optionalString (!isServer) ''
    mkdir -p $out/share/dynablaster
    cp -R data $out/share/dynablaster/
  '' + ''

    runHook postInstall
  '';

  preFixup = lib.optionalString (!isServer) ''
    qtWrapperArgs+=(
      --run "cd $out/share/dynablaster"
    )
  '';

  meta = with lib; {
    description = "This is a remake of the game Dynablaster, released by Hudson Soft in 1991"
      + lib.optionalString isServer " (dedicated server)";
    mainProgram = "dynablaster" + lib.optionalString isServer "-server";
    homepage = "https://github.com/varnholt/dynablaster_revenge";
    maintainers = with maintainers; [ luz ];
    license = with licenses; [ cc-by-nc-40 ];
    platforms = platforms.all;
    broken = (!isServer) && (
      # Missing audio backend code, unplayable even when patched
      stdenv.isDarwin ||
      # https://github.com/varnholt/dynablaster_revenge/issues/6
      stdenv.isAarch64
    );
  };
}
