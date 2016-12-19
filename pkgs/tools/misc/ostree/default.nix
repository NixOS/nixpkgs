{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gtk_doc, gobjectIntrospection
, libgsystem, xz, e2fsprogs, libsoup, gpgme, which, autoconf, automake, libtool, fuse
, libcap, yacc, libxslt, docbook_xsl, docbook_xml_dtd_42
}:

let
  libglnx-src = fetchFromGitHub {
    owner  = "GNOME";
    repo   = "libglnx";
    rev    = "36396b49ad6636c9959f3dfac5e04d41584b1a92";
    sha256 = "146flrpzybm2s12wg05rnglnfd2f2jx3xzvns2pq28kvg09bgcfn";
  };

  bsdiff-src = fetchFromGitHub {
    owner  = "mendsley";
    repo   = "bsdiff";
    rev    = "1edf9f656850c0c64dae260960fabd8249ea9c60";
    sha256 = "1h71d2h2d3anp4msvpaff445rnzdxii3id2yglqk7af9i43kdsn1";
  };

  version = "2016.11";
in stdenv.mkDerivation {
  name = "ostree-${version}";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "ostreedev";
    repo   = "ostree";
    sha256 = "19xmg01mxdykx74r9ra11hc15qd1fjqbxdn23jrn2pcvz8dw9zgc";
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

