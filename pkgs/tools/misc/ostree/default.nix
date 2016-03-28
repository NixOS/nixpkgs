{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gtk_doc, gobjectIntrospection
, libgsystem, xz, e2fsprogs, libsoup, gpgme
}:

stdenv.mkDerivation {
  name = "ostree-2015.3";

  meta = with stdenv.lib; {
    description = "Git for operating system binaries";
    homepage    = "http://live.gnome.org/OSTree/";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux;
  };

  src = fetchFromGitHub {
    owner = "GNOME";
    repo = "ostree";
    rev = "v2015.3";
    sha256 = "1n5q0yxwqx4pqiww3yjmqxl5835kknpw1bnwzbpanmyndnnl88dd";
  };

  nativeBuildInputs = [
    autoreconfHook pkgconfig gtk_doc gobjectIntrospection
  ];

  buildInputs = [ libgsystem xz e2fsprogs libsoup gpgme ];

  preAutoreconf = ''
    mkdir m4
    gtkdocize
  '';
}
