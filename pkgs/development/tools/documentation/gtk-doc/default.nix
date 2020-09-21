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
  pname = "gtk-doc-unstable";
  version = "2020-08-21";

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    # 1.32.1 is needed for glib, see https://gitlab.gnome.org/GNOME/gtk-doc/-/issues/128
    rev = "b2092227f5b6718c27380d6a7bd6842ffa008d56";
    sha256 = "0jqkyj96dm4c45j4axs4196qiqsphbg362n4fywh56hsmr3cx7bj";
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

  # find: ‘...-gtk-doc-1.32/lib/python3.8/site-packages’: No such file or directory
  # https://github.com/NixOS/nixpkgs/pull/90208#issuecomment-644051108
  dontUsePythonRecompileBytecode = true;

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
