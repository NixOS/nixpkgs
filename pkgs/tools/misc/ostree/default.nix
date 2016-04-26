{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gtk_doc, gobjectIntrospection
, libgsystem, xz, e2fsprogs, libsoup, gpgme, which, autoconf, automake, libtool, fuse
, libcap, yacc, libxslt, docbook_xsl, docbook_xml_dtd_42
}:

let
  libglnx-src = fetchFromGitHub {
    owner  = "GNOME";
    repo   = "libglnx";
    rev    = "769522753c25537e520adc322fa62e5390272add";
    sha256 = "0gfc8dl63xpmf73dwb1plj7cymq7z6w6wq5m06yx8jymwhq7x1l8";
  };

  bsdiff-src = fetchFromGitHub {
    owner  = "mendsley";
    repo   = "bsdiff";
    rev    = "1edf9f656850c0c64dae260960fabd8249ea9c60";
    sha256 = "1h71d2h2d3anp4msvpaff445rnzdxii3id2yglqk7af9i43kdsn1";
  };
in stdenv.mkDerivation rec {
  rev = "v2016.5";
  name = "ostree-${rev}";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "ostreedev";
    repo   = "ostree";
    sha256 = "1dfyhzgv94ldjv2l4jxf4xhks2z5ljljqa3k579qskds755n6kvg";
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
  '';

  meta = with stdenv.lib; {
    description = "Git for operating system binaries";
    homepage    = "http://live.gnome.org/OSTree/";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}

