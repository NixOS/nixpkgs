{ stdenv
, lib

, fetchFromGitHub

, pkg-config
, meson
, ninja

, jack
, alsa-lib
, libopus
, libsamplerate
, libsndfile
, readline
, zita-alsa-pcmi
, zita-resampler
}:

stdenv.mkDerivation (final: {
  pname = "jack-example-tools";
  version = "4";

  src = fetchFromGitHub {
    owner = "jackaudio";
    repo = "jack-example-tools";
    rev = "tags/${final.version}";
    hash = "sha256-5jmynNxwNVLxEZ1MaqQUG6kRwipDkjhrdDCbZHtmAHk=";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [
    jack
    alsa-lib
    libopus
    libsamplerate
    libsndfile
    readline
    zita-alsa-pcmi
    zita-resampler
  ];

  postPatch = ''
    patchShebangs scripts
  '';

  # no tests defined, but prepare for some in the future.
  doCheck = true;

  meta = with lib; {
    description = "Official examples and tools from the JACK project";
    homepage = "https://jackaudio.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ pennae ];
  };
})
