{ stdenv, fetchurl, autoreconfHook, pkgconfig, perl, python3, libxml2Python, libxslt, which
, docbook_xml_dtd_43, docbook_xsl, gnome-doc-utils, gettext, itstool, gnome3
, withDblatex ? false, dblatex
}:

stdenv.mkDerivation rec {
  pname = "gtk-doc";
  version = "1.29";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1cc6yl8l275qn3zpjl6f0s4fwmkczngjr9hhsdv74mln4h08wmql";
  };

  patches = [
    passthru.respect_xml_catalog_files_var_patch
  ];

  outputDevdoc = "out";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs =
    [ pkgconfig perl python3 libxml2Python libxslt docbook_xml_dtd_43 docbook_xsl
      gnome-doc-utils gettext which itstool
    ] ++ stdenv.lib.optional withDblatex dblatex;

  configureFlags = [ "--disable-scrollkeeper" ];

  # Make pygments available for binaries, python.withPackages creates a wrapper
  # but scripts are not allowed in shebangs so we link it into sys.path.
  postInstall = ''
    ln -s ${python3.pkgs.pygments}/${python3.sitePackages}/* $out/share/gtk-doc/python/
  '';

  doCheck = false; # requires a lot of stuff
  doInstallCheck = false; # fails

  passthru = {
    # Consumers are expected to copy the m4 files to their source tree, let them reuse the patch
    respect_xml_catalog_files_var_patch = ./respect-xml-catalog-files-var.patch;
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    description = "Tools to extract documentation embedded in GTK+ and GNOME source code";
    homepage = "https://www.gtk.org/gtk-doc";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
  };
}
