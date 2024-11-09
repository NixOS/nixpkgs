{ stdenv
, lib
, makeBinaryWrapper
, fetchurl
, unzip
, ffmpeg
, mkvtoolnix
, tesseract
, handbrake
}:

stdenv.mkDerivation rec {
  pname = "tdarr-server";
  version = "2.26.01";
  src = fetchurl {
    # Urls can be found here https://storage.tdarr.io/versions.json
    url = "https://storage.tdarr.io/versions/${version}/linux_x64/Tdarr_Server.zip";
    sha256 = "sha256-jIPPss22aCFydWcBE30IXBc6zDsOzc27nm4StOd4VCE=";
  };

  buildInputs = [
    tesseract
  ];

  nativeBuildInputs = [
    unzip
    makeBinaryWrapper
  ];

  unpackPhase = ''
    unzip $src
  '';

  dontConfigure = true;
  dontBuild = true;

  patchPhase = ''
    # Remove bundled ffmpeg, since we will be using the one from nixpkgs
    rm -rf ./node_modules/ffmpeg-static/ffmpeg
    # rm -rf ./node_modules/@ffprobe-installer/linux-x64/ffprobe
  '';

  installPhase =
    let
      binName = "Tdarr_Server";
      trayBinName = "Tdarr_Server_Tray";
    in
    ''
      mkdir -p $out
      cp -r ./ $out
      mkdir $out/bin
      # ln -s $out/${binName} $out/bin/${binName}
      makeBinaryWrapper $out/${binName} $out/bin/${binName} \
        --set ffmpegPath ${ffmpeg}/bin/ffmpeg \
        --set handbrakePath ${handbrake}/bin/HandBrakeCLI \
        --set mkvpropeditPath ${mkvtoolnix}/bin/mkvpropedit \
        --set ffprobePath ${ffmpeg}/bin/ffprobe
      # ln -s $out/${trayBinName} $out/bin/${trayBinName}
    '';

  meta = with lib; {
    mainProgram = "Tdarr_Server";
    description = "Distributed transcode automation";
    homepage = "https://tdarr.io";
    license = licenses.unfree; # TODO: figure out if license is redistributable
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ];
  };
}
