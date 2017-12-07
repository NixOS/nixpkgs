{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gtk_doc, gobjectIntrospection
, libgsystem, xz, e2fsprogs, libsoup, gpgme, which, autoconf, automake, libtool, fuse
, libcap, yacc, libxslt, docbook_xsl, docbook_xml_dtd_42
}:

let
  libglnx-src = fetchFromGitHub {
    owner  = "GNOME";
    repo   = "libglnx";
    rev    = "50a0feaba03ffa5a1980d3a14487276b8f49f8a6";
    sha256 = "1rn5jdh84y1yfpqmvidx82lkm0jr7scjzdrps57r37ksxvrk3ibs";
  };

  bsdiff-src = fetchFromGitHub {
    owner  = "mendsley";
    repo   = "bsdiff";
    rev    = "7d70d8f4ff48345bc76e314c9d98da91f78873fa";
    sha256 = "0ai2kykj8i4bqcy3gry36r3n4ax0fldncfhksl5b293nf2fihnws";
  };

  version = "2017.9";
in stdenv.mkDerivation {
  name = "ostree-${version}";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "ostreedev";
    repo   = "ostree";
    sha256 = "1040xcw8qcs6xq8x4wg47hha3915qzb6lndb38wjyn6wzl1680q3";
  };

  nativeBuildInputs = [
    autoconf automake libtool pkgconfig gtk_doc gobjectIntrospection which yacc
    libxslt docbook_xsl docbook_xml_dtd_42
  ];

  buildInputs = [ libgsystem xz e2fsprogs libsoup gpgme fuse libcap ];

  prePatch = ''
    rmdir libglnx bsdiff
    cp --no-preserve=mode -r ${libglnx-src} libglnx
    cp --no-preserve=mode -r ${bsdiff-src} bsdiff
  '';

  preConfigure = ''
    env NOCONFIGURE=1 ./autogen.sh

    configureFlags+="--with-systemdsystemunitdir=$out/lib/systemd/system"
  '';

  meta = with stdenv.lib; {
    description = "Git for operating system binaries";
    homepage    = "http://live.gnome.org/OSTree/";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}

