{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, cairo
, libjpeg_turbo
, libpng
, libossp_uuid
, freerdp
, pango
, libssh2
, libvncserver
, libpulseaudio
, openssl
, libvorbis
, libwebp
, pkg-config
, perl
, libtelnet
, inetutils
, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "guacamole";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "guacamole-server";
    rev = version;
    sha256 = "sha256-aosKpgMJxTxhXbuqIgpeR65pmr5GGraBOLCzmpYZ2qs=";
  };

  NIX_CFLAGS_COMPILE= [
    "-Wno-error=format-truncation"
    "-Wno-error=format-overflow"
  ];

  buildInputs = [
    freerdp
    autoreconfHook
    pkg-config
    cairo
    libpng
    libjpeg_turbo
    libossp_uuid
    pango
    libssh2
    libvncserver
    libpulseaudio
    openssl
    libvorbis
    libwebp
    libtelnet
    perl
    makeWrapper
  ];

  propogatedBuildInputs = [
    freerdp
    autoreconfHook
    pkg-config
    cairo
    libpng
    libjpeg_turbo
    libossp_uuid
    freerdp
    pango
    libssh2
    libvncserver
    libpulseaudio
    openssl
    libvorbis
    libwebp
    inetutils
  ];

  patchPhase = ''
    substituteInPlace ./src/protocols/rdp/keymaps/generate.pl --replace /usr/bin/perl "${perl}/bin/perl"
    substituteInPlace ./src/protocols/rdp/Makefile.am --replace "-Werror -Wall" "-Wall"
  '';

  postInstall = ''
    wrapProgram $out/sbin/guacd --prefix LD_LIBRARY_PATH ":" $out/lib
    '';

  meta = with lib; {
    description = "Clientless remote desktop gateway";
    homepage = "https://guacamole.incubator.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ tomberek ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}

