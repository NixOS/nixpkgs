{ lib, stdenv, fetchFromGitLab, pkg-config
, withLibui ? false, gtk3
, withUdisks ? false, udisks, glib
, withWriteOnly ? false
, libX11 }:

stdenv.mkDerivation rec {
  pname = "usbimager"
    + (if withLibui then "-gtk" else "-x11")
    + (if withWriteOnly then "-wo" else "");
  version = "1.0.8";

  src = fetchFromGitLab {
    owner = "bztsrc";
    repo = "usbimager";
    rev = version;
    sha256 = "1j0g1anmdwc3pap3m4kfzqjfkn7q0vpmqniii2kcz7svs5h3ybga";
  };

  sourceRoot = "source/src/";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals (withUdisks && stdenv.isLinux) [ udisks glib ]
    ++ lib.optional withLibui gtk3
    ++ lib.optional (!withLibui) libX11;
    # libui is bundled with the source of usbimager as a compiled static libary

  postPatch = ''
    sed -i \
      -e 's|install -m 2755 -g disk|install |g' \
      -e 's|-I/usr/include/gio-unix-2.0|-I${glib.dev}/include/gio-unix-2.0|g' \
      -e 's|install -m 2755 -g $(GRP)|install |g' Makefile
  '';

  dontConfigure = true;

  makeFlags =  [ "PREFIX=$(out)" ]
    ++ lib.optional withLibui "USE_LIBUI=yes"
    ++ lib.optional (!withLibui) "USE_X11=yes"
    ++ lib.optional (withUdisks && stdenv.isLinux) "USE_UDISKS2=yes"
    ++ lib.optional withWriteOnly "USE_WRONLY=yes";

  meta = with lib; {
    description = "A very minimal GUI app that can write compressed disk images to USB drives"
      + (if withLibui then " (GTK+" else " (X11")
      + (if withWriteOnly then ", write-only interface)" else ")");
    homepage = "https://gitlab.com/bztsrc/usbimager";
    license = licenses.mit;
    maintainers = with maintainers; [ vdot0x23 ];
    # windows and darwin could work, but untested
    # feel free add them if you have a machine to test
    platforms = with platforms; linux;
  };
}
