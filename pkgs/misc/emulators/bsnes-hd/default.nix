{ lib, stdenv, fetchFromGitHub
, pkg-config
, libX11, libXv
, udev
, SDL2
, gtk2, gtksourceview
, alsa-lib, libao, openal, libpulseaudio
, libicns, Cocoa, OpenAL
}:

stdenv.mkDerivation {
  pname = "bsnes-hd";
  version = "10.6-beta";

  src = fetchFromGitHub {
    owner = "DerKoun";
    repo = "bsnes-hd";
    rev = "beta_10_6";
    sha256 = "0f3cd89fd0lqskzj98cc1pzmdbscq0psdjckp86w94rbchx7iw4h";
  };

  patches = [
    # Replace invocation of `sips` with an equivalent invocation of `png2icns`
    # while assembling the .app directory hierarchy in the macos build. The
    # `sips` executable isn't in our environment during the build, but
    # `png2icns` is available by way of the dependency on libicns.
    ./macos-replace-sips-with-png2icns.patch

    # During `make install` on macos the Makefile wants to move the .app into
    # the current user's home directory. This patches the Makefile such that
    # the .app ends up in $(prefix)/Applications. The $(prefix) variable will
    # be set to $out, so this will result in the .app ending up in the
    # Applications directory in the current nix profile.
    ./macos-copy-app-to-prefix.patch
  ];

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optionals stdenv.isDarwin [ libicns ];

  buildInputs = [ SDL2 libao ]
    ++ lib.optionals stdenv.isLinux [ libX11 libXv udev gtk2 gtksourceview alsa-lib openal libpulseaudio ]
    ++ lib.optionals stdenv.isDarwin [ Cocoa OpenAL ];

  enableParallelBuilding = true;

  makeFlags = [ "-C" "bsnes" "prefix=$(out)" ];

  meta = with lib; {
    description = "A fork of bsnes that adds HD video features";
    homepage = "https://github.com/DerKoun/bsnes-hd";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ stevebob ];
    platforms = platforms.unix;
  };
}
