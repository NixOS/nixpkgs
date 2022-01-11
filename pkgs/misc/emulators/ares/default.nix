{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, alsa-lib
, gtksourceview3
, libXv
, openal
, libpulseaudio
, libao
, udev
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "ares";
  version = "126";

  src = fetchFromGitHub {
    owner = "ares-emulator";
    repo = "ares";
    rev = "v${version}";
    sha256 = "1rj4vmz8lvpmfc6wni7222kagnw9f6jda9rcb6qky2kpizlp2d24";
  };

  parallel-rdp = fetchFromGitHub {
    owner = "Themaister";
    repo = "parallel-rdp-standalone";
    rev = "0dcebe11ee79288441e40e145c8f340d81f52316";
    sha256 = "1avp4wyfkhk5yfjqx5w3jbqghn2mq5la7k9248kjmnp9n9lip6w9";
  };

  patches = [
    ./fix-ruby.patch
  ];

  enableParallelBuilding = true;
  dontConfigure = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    gtksourceview3
    libXv
    openal
    libpulseaudio
    libao
    udev
    SDL2
  ];

  buildPhase = ''
    runHook preBuild

    rm -rf ares/n64/vulkan/parallel-rdp
    ln -sf ${parallel-rdp} ares/n64/vulkan/parallel-rdp
    make -C desktop-ui -j $NIX_BUILD_CORES openmp=true vulkan=true local=false hiro=gtk3

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/{applications,ares,pixmaps}}
    cp desktop-ui/out/ares $out/bin
    cp desktop-ui/resource/ares.desktop $out/share/applications
    cp desktop-ui/resource/{ares{.ico,.png},font.png} $out/share/pixmaps
    cp -r ares/{Shaders,System} $out/share/ares

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://ares.dev";
    description = "Open-source multi-system emulator with a focus on accuracy and preservation";
    license = licenses.isc;
    maintainers = with maintainers; [ Madouura ];
    platforms = platforms.all;
  };
}
