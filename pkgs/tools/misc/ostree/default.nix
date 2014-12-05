{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gtk_doc, gobjectIntrospection
, libgsystem, xz, e2fsprogs, libsoup, gpgme
}:

stdenv.mkDerivation {
  name = "ostree-2014.11";

  meta = with stdenv.lib; {
    description = "Git for operating system binaries";
    homepage    = "http://live.gnome.org/OSTree/";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ iyzsong ];
  };

  src = fetchFromGitHub {
    owner = "GNOME";
    repo = "ostree";
    rev = "v2014.11";
    sha256 = "152s94r744lyz64syagha2c4y4afblc178lr9mkk8h2d4xvp6nf5";
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
