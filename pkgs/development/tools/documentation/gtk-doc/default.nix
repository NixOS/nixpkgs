{ stdenv, fetchurl, autoreconfHook, pkgconfig, perl, python, libxml2Python, libxslt, which
, docbook_xml_dtd_43, docbook_xsl, gnome-doc-utils, dblatex, gettext, itstool
}:

stdenv.mkDerivation rec {
  name = "gtk-doc-${version}";
  version = "1.28";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk-doc/${version}/${name}.tar.xz";
    sha256 = "05apmwibkmn1icx05l8aw241lhymcx01zvk5i499cb150bijj7li";
  };

  patches = [
    passthru.respect_xml_catalog_files_var_patch
  ];

  outputDevdoc = "out";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs =
    [ pkgconfig perl python libxml2Python libxslt docbook_xml_dtd_43 docbook_xsl
      gnome-doc-utils dblatex gettext which itstool
    ];

  configureFlags = [ "--disable-scrollkeeper" ];

  # Make six available for binaries, python.withPackages creates a wrapper
  # but scripts are not allowed in shebangs so we link it into sys.path.
  postInstall = ''
    ln -s ${python.pkgs.six}/lib/python2.7/site-packages/* $out/share/gtk-doc/python/
  '';

  doCheck = false; # requires a lot of stuff
  doInstallCheck = false; # fails

  passthru = {
    # Consumers are expected to copy the m4 files to their source tree, let them reuse the patch
    respect_xml_catalog_files_var_patch = ./respect-xml-catalog-files-var.patch;
  };

  meta = with stdenv.lib; {
    homepage = https://www.gtk.org/gtk-doc;
    description = "Tools to extract documentation embedded in GTK+ and GNOME source code";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
  };
}
