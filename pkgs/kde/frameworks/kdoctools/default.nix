{
  mkKdeDerivation,
  docbook_xml_dtd_45,
  docbook-xsl-nons,
  perl,
  perlPackages,
  libxml2,
}:
mkKdeDerivation {
  pname = "kdoctools";

  # In nixpkgs KDE_INSTALL_DATADIR_KF is an absolute path, the below logic assumes it's a relative path.
  patches = [ ./datadir-absolute-path.patch ];

  # Perl could be used both at build time and at runtime.
  extraNativeBuildInputs = [
    perl
    perlPackages.URI
    libxml2
  ];
  extraBuildInputs = [
    docbook_xml_dtd_45
    docbook-xsl-nons
  ];
  extraPropagatedBuildInputs = [
    perl
    perlPackages.URI
  ];
}
