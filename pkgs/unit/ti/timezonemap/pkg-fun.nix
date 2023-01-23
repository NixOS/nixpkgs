{ lib, stdenv
, autoreconfHook
, fetchbzr
, pkg-config
, gtk3
, glib
, file
, gobject-introspection
, json-glib
, libsoup
}:

stdenv.mkDerivation rec {
  pname = "timezonemap";
  version = "0.4.5.1";

  src = fetchbzr {
    url = "lp:timezonemap";
    rev = "58";
    sha256 = "sha256-wCJXwgnN+aZVerjQCm8oT3xIcwmc4ArcEoCh9pMrt+E=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    glib
    json-glib
    libsoup
  ];

  configureFlags = [
    "CFLAGS=-Wno-error"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  preConfigure = ''
    for f in {configure,m4/libtool.m4}; do
      substituteInPlace $f\
        --replace /usr/bin/file ${file}/bin/file
    done
  '';

  postPatch = ''
    sed "s|/usr/share/libtimezonemap|$out/share/libtimezonemap|g" -i ./src/tz.h
  '';

  meta = with lib; {
    homepage = "https://launchpad.net/timezonemap";
    description = "A GTK+3 Timezone Map Widget";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
