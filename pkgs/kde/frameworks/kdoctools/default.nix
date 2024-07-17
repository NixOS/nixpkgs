{
  mkKdeDerivation,
  docbook_xml_dtd_45,
  docbook-xsl-nons,
  perl,
  perlPackages,
}:
mkKdeDerivation {
  pname = "kdoctools";

  # Perl could be used both at build time and at runtime.
  extraNativeBuildInputs = [
    perl
    perlPackages.URI
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
