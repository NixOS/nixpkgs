{ stdenv
, fetchFromGitLab
, meson
, ninja
, pkgconfig
, python3
, libxml2Python
, docbook_xml_dtd_43
, docbook_xsl
, libxslt
, gettext
, gnome3
, withDblatex ? false, dblatex
}:

stdenv.mkDerivation rec {
  pname = "gtk-doc";
  version = "1.30";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "GTK_DOC_${stdenv.lib.replaceStrings ["."] ["_"] version }";
    sha256 = "05lr6apj3pd3s59a7k6p45k9ywwrp577ra4pvkhxvb5p7v90c2fi";
  };

  patches = [
    passthru.respect_xml_catalog_files_var_patch
    # https://gitlab.gnome.org/GNOME/gtk-doc/issues/84
    ./0001-highlight-fix-permission-on-file-style.patch
  ];

  outputDevdoc = "out";

  nativeBuildInputs = [
    gettext
    meson
    ninja
  ];

  buildInputs = [
    docbook_xml_dtd_43
    docbook_xsl
    libxslt
    pkgconfig
    python3
    libxml2Python
  ]
  ++ stdenv.lib.optional withDblatex dblatex
  ;

  mesonFlags = [
    "-Dtests=false"
    "-Dyelp_manual=false"
  ];

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
    description = "Tools to extract documentation embedded in GTK and GNOME source code";
    homepage = "https://www.gtk.org/gtk-doc";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
  };
}
