{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libjack2,
  alsa-lib,
  libpulseaudio,
  faac,
  lame,
  libogg,
  libopus,
  libvorbis,
  libsamplerate,
}:

stdenv.mkDerivation rec {
  pname = "darkice";
  version = "1.4";

  src = fetchurl {
    url = "https://github.com/rafael2k/darkice/releases/download/v${version}/darkice-${version}.tar.gz";
    sha256 = "05yq7lggxygrkd76yiqby3msrgdn082p0qlvmzzv9xbw8hmyra76";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libopus
    libvorbis
    libogg
    libpulseaudio
    alsa-lib
    libsamplerate
    libjack2
    lame
  ];

  env.NIX_CFLAGS_COMPILE = "-fpermissive";

  configureFlags = [
    "--with-faac-prefix=${faac}"
    "--with-lame-prefix=${lame.lib}"
  ];

  patches = [ ./fix-undeclared-memmove.patch ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://darkice.org/";
    description = "Live audio streamer";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ikervagyok ];
  };
}
