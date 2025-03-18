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

, enableAlsa ? stdenv.isLinux
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

  postPatch = ''
    patchShebangs scripts
  '';

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [
    jack
    libopus
    libsamplerate
    libsndfile
    readline
  ] ++ lib.optionals enableAlsa [
    alsa-lib
    zita-alsa-pcmi
    zita-resampler
  ];

  mesonFlags = [
    (lib.mesonEnable "alsa_in_out" enableAlsa)
    (lib.mesonEnable "zalsa" enableAlsa)
  ];

  # no tests defined, but prepare for some in the future.
  doCheck = true;

  meta = with lib; {
    description = "Official examples and tools from the JACK project";
    homepage = "https://jackaudio.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ ];
  };
})
