{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gtk-doc, gobjectIntrospection
, libgsystem, xz, e2fsprogs, libsoup, gpgme, which, autoconf, automake, libtool, fuse
, libarchive, libcap, bzip2, yacc, libxslt, docbook_xsl, docbook_xml_dtd_42
}:

let
  libglnx-src = fetchFromGitHub {
    owner  = "GNOME";
    repo   = "libglnx";
    rev    = "5362f6bc3ff3e30f379e767b203d15c9e56d6f08";
    sha256 = "1l4vm7bx3cf4q44n3a1i2gszyryqyimcxvx54gna72q7dw130mrr";
  };

  bsdiff-src = fetchFromGitHub {
    owner  = "mendsley";
    repo   = "bsdiff";
    rev    = "1edf9f656850c0c64dae260960fabd8249ea9c60";
    sha256 = "1h71d2h2d3anp4msvpaff445rnzdxii3id2yglqk7af9i43kdsn1";
  };

  version = "2017.12";
in stdenv.mkDerivation {
  name = "ostree-${version}";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "ostreedev";
    repo   = "ostree";
    sha256 = "0gxvpzwz7z4zihz5hkn6ajv7f6gas4zi2pznhi5v6wy7cw06if68";
  };

  nativeBuildInputs = [
    autoconf automake libtool pkgconfig gtk-doc gobjectIntrospection which yacc
    libxslt docbook_xsl docbook_xml_dtd_42
  ];

  buildInputs = [ libgsystem xz e2fsprogs libsoup gpgme fuse libarchive libcap bzip2 ];

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
    homepage    = https://ostree.readthedocs.io/en/latest/;
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}

