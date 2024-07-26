{
  mkKdeDerivation,
  docbook_xml_dtd_45,
  docbook-xsl-nons,
  perl,
  perlPackages,
}:
mkKdeDerivation {
  pname = "kdoctools";

  # lots of self-references, the output is pretty small (~5MB), not worth trying to untangle
  outputs = ["out"];

  # Perl could be used both at build time and at runtime.
  extraNativeBuildInputs = [perl perlPackages.URI];
  extraBuildInputs = [docbook_xml_dtd_45 docbook-xsl-nons];
  extraPropagatedBuildInputs = [perl perlPackages.URI];
}
