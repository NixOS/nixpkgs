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
