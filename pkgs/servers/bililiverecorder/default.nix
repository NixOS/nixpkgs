{ lib
, stdenv
, fetchzip
, makeWrapper
, dotnetCorePackages
}:

let
  pname = "bililiverecorder";

  dotnet = with dotnetCorePackages; combinePackages [
    runtime_6_0
    aspnetcore_6_0
  ];

  version = "2.10.1";
  hash = "sha256-7F/Hgt0p73QY5Sa3MRP//x7EpfcHCbnAPKDf00XzUbw=";

in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchzip {
    url = "https://github.com/BililiveRecorder/BililiveRecorder/releases/download/v${version}/BililiveRecorder-CLI-any.zip";
    stripRoot = false;
    inherit hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}/.

    makeWrapper "${dotnet}/bin/dotnet" $out/bin/BililiveRecorder \
      --add-flags "$out/share/${pname}-${version}/BililiveRecorder.Cli.dll"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A convenient free open source bilibili live recording tool";
    homepage = "https://rec.danmuji.org/";
    changelog = "https://github.com/BililiveRecorder/BililiveRecorder/releases/tag/${version}";
    mainProgram = "BililiveRecorder";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zaldnoay ];
    platforms = platforms.unix;
  };
}
