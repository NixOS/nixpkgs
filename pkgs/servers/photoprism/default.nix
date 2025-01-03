{ pkgs, lib, stdenv, fetchFromGitHub, fetchzip, darktable, rawtherapee, ffmpeg_7, libheif, exiftool, imagemagick, makeWrapper, testers
, nixosTests
, librsvg }:

let
  version = "240711-2197af848";
  pname = "photoprism";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-ihDv5c5RUjDbFcAHJjzp/8qCwKfA+rlFXPziaYarzs8=";
  };

  libtensorflow = pkgs.callPackage ./libtensorflow.nix { };
  backend = pkgs.callPackage ./backend.nix { inherit libtensorflow src version; };
  frontend = pkgs.callPackage ./frontend.nix { inherit src version; };

  fetchModel = { name, hash }:
    fetchzip {
      inherit hash;
      url = "https://dl.photoprism.org/tensorflow/${name}.zip";
      stripRoot = false;
    };

  facenet = fetchModel {
    name = "facenet";
    hash = "sha256-aS5kkNhxOLSLTH/ipxg7NAa1w9X8iiG78jmloR1hpRo=";
  };

  nasnet = fetchModel {
    name = "nasnet";
    hash = "sha256-bF25jPmZLyeSWy/CGXZE/VE2UupEG2q9Jmr0+1rUYWE=";
  };

  nsfw = fetchModel {
    name = "nsfw";
    hash = "sha256-zy/HcmgaHOY7FfJUY6I/yjjsMPHR2Ote9ppwqemBlfg=";
  };

  assets_path = "$out/share/${pname}";
in
stdenv.mkDerivation {
  inherit pname version;

  nativeBuildInputs = [
    makeWrapper
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin ${assets_path}

    # install backend
    ln -s ${backend}/bin/photoprism $out/bin/photoprism
    wrapProgram $out/bin/photoprism \
      --set PHOTOPRISM_ASSETS_PATH ${assets_path} \
      --set PHOTOPRISM_DARKTABLE_BIN ${darktable}/bin/darktable-cli \
      --set PHOTOPRISM_RAWTHERAPEE_BIN ${rawtherapee}/bin/rawtherapee-cli \
      --set PHOTOPRISM_HEIFCONVERT_BIN ${libheif}/bin/heif-convert \
      --set PHOTOPRISM_RSVGCONVERT_BIN ${librsvg}/bin/rsvg-convert \
      --set PHOTOPRISM_FFMPEG_BIN ${ffmpeg_7}/bin/ffmpeg \
      --set PHOTOPRISM_EXIFTOOL_BIN ${exiftool}/bin/exiftool \
      --set PHOTOPRISM_IMAGEMAGICK_BIN ${imagemagick}/bin/convert

    # install frontend
    ln -s ${frontend}/assets/* ${assets_path}
    # install tensorflow models
    ln -s ${nasnet}/nasnet ${assets_path}
    ln -s ${nsfw}/nsfw ${assets_path}
    ln -s ${facenet}/facenet ${assets_path}

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion { package = pkgs.photoprism; };
  passthru.tests.photoprism = nixosTests.photoprism;

  meta = with lib; {
    homepage = "https://photoprism.app";
    description = "Personal Photo Management powered by Go and Google TensorFlow";
    inherit (libtensorflow.meta) platforms;
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ benesim ];
    mainProgram = "photoprism";
  };
}
