{ lib, stdenv, fetchpatch, fetchFromGitHub, pkg-config, autoreconfHook, wrapGAppsHook
, gnome, avahi, gtk3, libayatana-appindicator, libnotify, libpulseaudio
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "pasystray";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "christophgysin";
    repo = "pasystray";
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
