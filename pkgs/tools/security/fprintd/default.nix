{ thinkpad ? false
, stdenv
, fetchurl
, fetchpatch
, pkgconfig
, intltool
, libfprint-thinkpad ? null
, libfprint ? null
, glib
, dbus-glib
, polkit
, nss
, pam
, systemd
, autoreconfHook
, gtk-doc
}:

stdenv.mkDerivation rec {
  pname = "fprintd" + stdenv.lib.optionalString thinkpad "-thinkpad";
  version = "0.9.0";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/libfprint/fprintd/uploads/9dec4b63d1f00e637070be1477ce63c0/fprintd-${version}.tar.xz";
    sha256 = "182gcnwb6zjwmk0dn562rjmpbk7ac7dhipbfdhfic2sn1jzis49p";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/libfprint/fprintd/merge_requests/16.patch";
      sha256 = "1y39zsmxjll9hip8464qwhq5qg06c13pnafyafgxdph75lvhdll7";
    })
  ];

  nativeBuildInputs = [
    intltool
    pkgconfig
    autoreconfHook # Drop with above patch
    gtk-doc # Drop with above patch
  ];

  buildInputs = [
    glib
    dbus-glib
    polkit
    nss
    pam
    systemd
  ]
  ++ stdenv.lib.optional thinkpad libfprint-thinkpad
  ++ stdenv.lib.optional (!thinkpad) libfprint
  ;

  configureFlags = [
    # is hardcoded to /var/lib/fprint, this is for the StateDirectory install target
    "--localstatedir=${placeholder "out"}/var"
    "--sysconfdir=${placeholder "out"}/etc"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ];

  meta = with stdenv.lib; {
    homepage = https://fprint.freedesktop.org/;
    description = "D-Bus daemon that offers libfprint functionality over the D-Bus interprocess communication bus";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
