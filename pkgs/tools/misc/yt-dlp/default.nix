{ lib
, buildPythonPackage
, fetchPypi
, brotli
, certifi
, ffmpeg
, rtmpdump
, atomicparsley
, pycryptodomex
, websockets
, mutagen
, secretstorage
, atomicparsleySupport ? true
, ffmpegSupport ? true
, rtmpSupport ? true
, withAlias ? false # Provides bin/youtube-dl for backcompat
, update-python-libraries
}:

buildPythonPackage rec {
  pname = "yt-dlp";
  # The websites yt-dlp deals with are a very moving target. That means that
  # downloads break constantly. Because of that, updates should always be backported
  # to the latest stable release.
  version = "2023.9.24";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-z8+1/8EgE7auS4x6KDp+RimI8bSSg94pHei/vgU7gHM=";
  };

  propagatedBuildInputs = [
    brotli
    certifi
    mutagen
    pycryptodomex
    secretstorage  # "optional", as in not in requirements.txt, needed for `--cookies-from-browser`
    websockets
  ];

  # Ensure these utilities are available in $PATH:
  # - ffmpeg: post-processing & transcoding support
  # - rtmpdump: download files over RTMP
  # - atomicparsley: embedding thumbnails
  makeWrapperArgs =
    let
      packagesToBinPath = []
        ++ lib.optional atomicparsleySupport atomicparsley
        ++ lib.optional ffmpegSupport ffmpeg
        ++ lib.optional rtmpSupport rtmpdump;
    in lib.optionalString (packagesToBinPath != [])
    [ ''--prefix PATH : "${lib.makeBinPath packagesToBinPath}"'' ];

  setupPyBuildFlags = [
    "build_lazy_extractors"
  ];

  # Requires network
  doCheck = false;

  postInstall = lib.optionalString withAlias ''
    ln -s "$out/bin/yt-dlp" "$out/bin/youtube-dl"
  '';

  passthru.updateScript = [ update-python-libraries (toString ./.) ];

  meta = with lib; {
    homepage = "https://github.com/yt-dlp/yt-dlp/";
    description = "Command-line tool to download videos from YouTube.com and other sites (youtube-dl fork)";
    longDescription = ''
      yt-dlp is a youtube-dl fork based on the now inactive youtube-dlc.

      youtube-dl is a small, Python-based command-line program
      to download videos from YouTube.com and a few more sites.
      youtube-dl is released to the public domain, which means
      you can modify it, redistribute it or use it however you like.
    '';
    license = licenses.unlicense;
    maintainers = with maintainers; [ mkg20001 SuperSandro2000 marsam ];
    mainProgram = "yt-dlp";
  };
}
