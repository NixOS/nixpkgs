{ stdenv, fetchFromGitHub
, meson, ninja, pkg-config, scdoc, wayland # wayland-scanner
, wayland-protocols, libseccomp
}:

stdenv.mkDerivation rec {
  pname = "wob";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "francma";
    repo = pname;
    rev = version;
    sha256 = "1j3l4v9iqhidn1b6vx86px9hz5wbsbgj3zy2jzwf9204k5sfv715";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace "version: '0.6'" "version: '${version}'"
  '';

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
