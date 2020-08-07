{ stdenv, fetchFromGitHub
, meson, ninja, pkg-config, scdoc, wayland # wayland-scanner
, wayland-protocols, libseccomp
}:

stdenv.mkDerivation rec {
  pname = "wob";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "francma";
    repo = pname;
    rev = version;
    sha256 = "02skvaj1q05c2r9fx83dlq44aksbw2fhpiv529rd154lh3pf07bc";
  };

  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland ];
  buildInputs = [ wayland-protocols ]
    ++ stdenv.lib.optional stdenv.isLinux libseccomp;

  mesonFlags = stdenv.lib.optional stdenv.isLinux "-Dseccomp=enabled";

  meta = with stdenv.lib; {
    description = "A lightweight overlay bar for Wayland";
    longDescription = ''
      A lightweight overlay volume/backlight/progress/anything bar for Wayland,
      inspired by xob.
    '';
    inherit (src.meta) homepage;
    changelog = "https://github.com/francma/wob/releases/tag/${version}";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
