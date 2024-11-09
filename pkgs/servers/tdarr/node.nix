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

let
  binName = "Tdarr_Node";
in
stdenv.mkDerivation rec {
  pname = "tdarr-node";
  version = "2.26.01";
  src = fetchurl {
    # Urls can be found here https://storage.tdarr.io/versions.json
    url = "https://storage.tdarr.io/versions/${version}/linux_x64/Tdarr_Node.zip";
    sha256 = "sha256-GAcK5g2fh9B6ZI8fYtLjWC0PntX5lOukUO04PGqxLzw=";
  };

  buildInputs = [
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

  installPhase = ''
    mkdir -p $out
    cp -r ./ $out
    mkdir $out/bin
    makeBinaryWrapper $out/${binName} $out/bin/${binName} \
      --set ffmpegPath ${ffmpeg}/bin/ffmpeg \
      --set handbrakePath ${handbrake}/bin/HandBrakeCLI \
      --set mkvpropeditPath ${mkvtoolnix}/bin/mkvpropedit \
      --set ffprobePath ${ffmpeg}/bin/ffprobe
  '';

  meta = with lib; {
    mainProgram = binName;
    description = "Distributed transcode automation";
    homepage = "https://tdarr.io";
    license = licenses.unfree; # TODO: figure out if license is redistributable
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ];
  };
}
