{ lib, stdenv, fetchpatch, fetchFromGitHub, pkg-config, autoreconfHook, wrapGAppsHook
, gnome, avahi, gtk3, libayatana-appindicator, libnotify, libpulseaudio
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "pasystray";
<<<<<<< HEAD
  version = "0.8.2";
=======
  version = "0.7.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "christophgysin";
    repo = "pasystray";
<<<<<<< HEAD
    rev = version;
    sha256 = "sha256-QaTQ8yUviJaFEQaQm2vYAUngqHliKe8TDYqfWt1Nx/0=";
  };

  patches = [
    # Use ayatana-appindicator instead of appindicator
    # https://github.com/christophgysin/pasystray/issues/98
    (fetchpatch {
      url = "https://sources.debian.org/data/main/p/pasystray/0.8.1-1/debian/patches/0001-Build-against-ayatana-appindicator.patch";
      sha256 = "sha256-/HKPqVARfHr/3Vyls6a1n8ejxqW9Ztu4+8KK4jK8MkI=";
    })
    # Require X11 backend
    # https://github.com/christophgysin/pasystray/issues/90#issuecomment-361881076
    (fetchpatch {
      url = "https://sources.debian.org/data/main/p/pasystray/0.8.1-1/debian/patches/0002-Require-X11-backend.patch";
      sha256 = "sha256-6njC3vqBPWFS1xAsa1katQ4C0KJdVkHAP1MCPiZ6ELM=";
    })
   ];
=======
    rev = "${pname}-${version}";
    sha256 = "0xx1bm9kimgq11a359ikabdndqg5q54pn1d1dyyjnrj0s41168fk";
  };

  patches = [
    # https://github.com/christophgysin/pasystray/issues/90#issuecomment-306190701
    ./fix-wayland.patch

    # https://github.com/christophgysin/pasystray/issues/98
    (fetchpatch {
      url = "https://sources.debian.org/data/main/p/pasystray/0.7.1-1/debian/patches/0001-Build-against-ayatana-appindicator.patch";
      sha256 = "0hijphrf52n2zfwdnrmxlp3a7iwznnkb79awvpzplz0ia2lqywpw";
    })
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config autoreconfHook wrapGAppsHook ];
  buildInputs = [
    gnome.adwaita-icon-theme
    avahi gtk3 libayatana-appindicator libnotify libpulseaudio
    gsettings-desktop-schemas
  ];

  meta = with lib; {
    description = "PulseAudio system tray";
    homepage = "https://github.com/christophgysin/pasystray";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ exlevan kamilchm ];
    platforms = platforms.linux;
  };
}
