{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, autoPatchelfHook
, autoreconfHook
, cairo
, ffmpeg_4-headless
, freerdp
, libjpeg_turbo
, libpng
, libossp_uuid
, libpulseaudio
, libssh2
, libtelnet
, libvncserver
, libvorbis
, libwebp
, libwebsockets
, makeBinaryWrapper
, openssl
, pango
, perl
, nixosTests
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guacamole-server";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "guacamole-server";
    rev = finalAttrs.version;
    hash = "sha256-Jke9Sp/T/GyamTq7lyu8JakJHqEwSrer0v1DugSg7JY=";
  };

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=format-truncation"
    "-Wno-error=format-overflow"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    autoreconfHook
    makeBinaryWrapper
    perl
    pkg-config
  ];

  buildInputs = [
    cairo
    ffmpeg_4-headless
    freerdp
    libjpeg_turbo
    libossp_uuid
    libpng
    libpulseaudio
    libssh2
    libtelnet
    libvncserver
    libvorbis
    libwebp
    libwebsockets
    openssl
    pango
  ];

  configureFlags = [
    "--with-freerdp-plugin-dir=${placeholder "out"}/lib"
  ];

  postPatch = ''
    patchShebangs ./src/protocols/rdp/**/*.pl
  '';

  postInstall = ''
    ln -s ${freerdp}/lib/* $out/lib/
    wrapProgram $out/sbin/guacd --prefix LD_LIBRARY_PATH ":" $out/lib
  '';

  passthru.tests = {
    inherit (nixosTests) guacamole-server;
  };

  meta = {
    description = "Clientless remote desktop gateway";
    homepage = "https://guacamole.apache.org/";
    license = lib.licenses.asl20;
    mainProgram = "guacd";
    maintainers = [ lib.maintainers.drupol ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
})
