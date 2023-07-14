{ lib, stdenv, fetchFromGitHub, pkg-config, meson, ninja, bash
, jack, libsamplerate, libsndfile

# Optional Dependencies
, readline ? null
, libopus ? null
, alsa-lib ? null
, zita-alsa-pcmi ? null
, zita-resampler ? null
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jack-example-tools";
  version = "4";

  src = fetchFromGitHub {
    owner = "jackaudio";
    repo = "jack-example-tools";
    rev = finalAttrs.version;
    sha256 = "sha256-5jmynNxwNVLxEZ1MaqQUG6kRwipDkjhrdDCbZHtmAHk=";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = let
    shouldUsePkg = pkg: pkg != null && lib.meta.availableOn stdenv.hostPlatform pkg;
  in [
    jack libsamplerate libsndfile libopus readline
  ] ++ lib.filter shouldUsePkg [
    alsa-lib zita-alsa-pcmi zita-resampler
  ];

  prePatch = ''
    substituteInPlace scripts/meson_create_symlink \
        --replace "/usr/bin/env sh" ${bash}/bin/bash
  '';

  meta = with lib; {
    description = "JACK audio connection kit example clients and tools";
    homepage = "https://jackaudio.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ goibhniu rvl ];
  };
})
