{
  dpkg,
  stdenv,
  lib,
  fetchurl,
  jre8,
  jsvc,
  lsb-release,
  libcap,
  util-linux,
  makeWrapper,
  autoPatchelfHook,
  glibc,
  gcc-unwrapped,
}:

stdenv.mkDerivation rec {
  pname = "unifi-video";
  version = "3.10.13";
  src = fetchurl {
    urls = [
      "https://dl.ui.com/firmwares/ufv/v${version}/unifi-video.Debian9_amd64.v${version}.deb"
      "https://archive.org/download/unifi-video.Debian9_amd64.v${version}/unifi-video.Debian9_amd64.v${version}.deb"
    ];
    sha256 = "06mxjdizs4mhm1by8kj4pg5hhdi8ns6x75ggwyp1k6zb26jvvdny";
  };

  buildInputs = [
    jre8
    jsvc
    lsb-release
    libcap
    util-linux
  ];
  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
    glibc
    gcc-unwrapped
  ];

  unpackCmd = ''
    runHook preUnpack

    dpkg-deb -x $src .
    rm -r etc

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -ar sbin $out/bin
    cp -ar lib share $out
    chmod +x $out/bin/*
    wrapProgram $out/bin/unifi-video --set JAVA_HOME "${jre8}" --prefix PATH : ${
      lib.makeBinPath [
        jre8
        lsb-release
        libcap
        util-linux
      ]
    }

    runHook postInstall
  '';

  meta = with lib; {
    description = "Unifi Video NVR (aka Airvision) is a software package for controlling Unifi cameras";
    longDescription = ''
      Unifi Video is the NVR server software which can monitor and
      record footage from supported Unifi video cameras
    '';
    homepage = "https://www.ui.com";
    downloadPage = "https://www.ui.com/download/unifi-video/";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.unfree;
    maintainers = [ maintainers.rsynnest ];
    platforms = [ "x86_64-linux" ];
    knownVulnerabilities = [ "Upstream support for Unifi Video ended January 1st, 2021." ];
  };
}
