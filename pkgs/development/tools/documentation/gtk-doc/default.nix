{ stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, python3
, docbook_xml_dtd_43
, docbook_xsl
, libxslt
, gettext
, gnome3
, withDblatex ? false, dblatex
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gtk-doc";
  version = "1.32";

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "GTK_DOC_${stdenv.lib.replaceStrings ["."] ["_"] version }";
    sha256 = "14fihxj662gg4ln1ngff6s52zzkpbcc58qa0nxysxypnhp0h4ypk";
  };

  patches = [
    passthru.respect_xml_catalog_files_var_patch
  ];

  outputDevdoc = "out";

  nativeBuildInputs = [
    pkg-config
    gettext
    meson
    ninja
    libxslt # for xsltproc
  ];

  buildInputs = [
    docbook_xml_dtd_43
    docbook_xsl
    libxslt
  ] ++ stdenv.lib.optionals withDblatex [
    dblatex
  ];

  pythonPath = with python3.pkgs; [
    pygments # Needed for https://gitlab.gnome.org/GNOME/gtk-doc/blob/GTK_DOC_1_32/meson.build#L42
    (anytree.override { withGraphviz = false; })
    lxml
  ];

  mesonFlags = [
    "-Dtests=false"
    "-Dyelp_manual=false"
  ];

  doCheck = false; # requires a lot of stuff
  doInstallCheck = false; # fails

  postFixup = ''
    # Do not propagate Python
    substituteInPlace $out/nix-support/propagated-build-inputs \
      --replace "${python3}" ""
  '';

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
    maintainers = with maintainers; [ pSub worldofpeace ];
  };
}
