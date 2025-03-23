{
  lib,
  fetchurl,
  fetchpatch,
  buildPythonPackage,
  zip,
  ffmpeg,
  rtmpdump,
  atomicparsley,
  pycryptodome,
  pandoc,
  # Pandoc is required to build the package's man page. Release tarballs contain a
  # formatted man page already, though, it will still be installed. We keep the
  # manpage argument in place in case someone wants to use this derivation to
  # build a Git version of the tool that doesn't have the formatted man page
  # included.
  generateManPage ? false,
  ffmpegSupport ? true,
  rtmpSupport ? true,
  hlsEncryptedSupport ? true,
  installShellFiles,
  makeWrapper,
}:

buildPythonPackage rec {

  pname = "youtube-dl";
  # The websites youtube-dl deals with are a very moving target. That means that
  # downloads break constantly. Because of that, updates should always be backported
  # to the latest stable release.
  version = "2021.12.17";

  src = fetchurl {
    url = "https://yt-dl.org/downloads/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-nzuZyLd4RVFltFJfIVBehsf/Vl86wxnhlzPYEBlBNd8=";
  };

  patches = [
    # Fixes throttling on youtube.com by decoding a "n-parameter". Without the patch
    # downloads are capped at about 80KiB/s. See, e.g.,
    #
    #   https://github.com/ytdl-org/youtube-dl/issues/29326
    #
    # The patch comes from PR https://github.com/ytdl-org/youtube-dl/pull/30184#issuecomment-1025261055
    # plus follow-up (1e677567) from https://github.com/ytdl-org/youtube-dl/pull/30582
    (fetchpatch {
      name = "fix-youtube-dl-speed.patch";
      url = "https://github.com/ytdl-org/youtube-dl/compare/57044eacebc6f2f3cd83c345e1b6e659a22e4773...1e677567cd083d43f55daef0cc74e5fa24575ae3.diff";
      sha256 = "11s0j3w60r75xx20p0x2j3yc4d3yvz99r0572si8b5qd93lqs4pr";
    })
    # The above patch may fail to decode the n-parameter (if, say, YouTube is updated). Failure to decode
    # it blocks the download instead of falling back to the throttled version. The patch below implements
    # better fallback behaviour.
    (fetchpatch {
      name = "avoid-crashing-if-nsig-decode-fails.patch";
      url = "https://github.com/ytdl-org/youtube-dl/commit/41f0043983c831b7c0c3614340d2f66ec153087b.diff";
      sha256 = "sha256-a72gWhBXCLjuBBD36PpZ5F/AHBdiBv4W8Wf9g4P/aBY=";
    })
    # YouTube changed the n-parameter format in April 2022, so decoder updates are required.
    (fetchpatch {
      name = "fix-n-descrambling.patch";
      url = "https://github.com/ytdl-org/youtube-dl/commit/a0068bd6bec16008bda7a39caecccbf84881c603.diff";
      sha256 = "sha256-tSuEns4jputa2nOOo6JsFXpK3hvJ/+z1/ymcLsd3A6w=";
    })
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];
  buildInputs = [ zip ] ++ lib.optional generateManPage pandoc;
  propagatedBuildInputs = lib.optional hlsEncryptedSupport pycryptodome;

  # Ensure these utilities are available in $PATH:
  # - ffmpeg: post-processing & transcoding support
  # - rtmpdump: download files over RTMP
  # - atomicparsley: embedding thumbnails
  makeWrapperArgs =
    let
      packagesToBinPath =
        [ atomicparsley ] ++ lib.optional ffmpegSupport ffmpeg ++ lib.optional rtmpSupport rtmpdump;
    in
    [ ''--prefix PATH : "${lib.makeBinPath packagesToBinPath}"'' ];

  setupPyBuildFlags = [
    "build_lazy_extractors"
  ];

  postInstall = ''
    installShellCompletion youtube-dl.zsh
  '';

  # Requires network
  doCheck = false;

  meta = with lib; {
    homepage = "https://ytdl-org.github.io/youtube-dl/";
    description = "Command-line tool to download videos from YouTube.com and other sites";
    longDescription = ''
      youtube-dl is a small, Python-based command-line program to download
      videos from YouTube.com and a few more sites.  youtube-dl is released to
      the public domain, which means you can modify it, redistribute it or use
      it however you like.
    '';
    license = licenses.publicDomain;
    maintainers = with maintainers; [
      bluescreen303
      fpletz
    ];
    platforms = with platforms; linux ++ darwin;
    mainProgram = "youtube-dl";
    knownVulnerabilities = [
      "youtube-dl is unmaintained, migrate to yt-dlp, if possible"
    ];
  };
}
