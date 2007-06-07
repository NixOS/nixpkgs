{stdenv, fetchurl, libxml2}:

stdenv.mkDerivation {
  name = "libsmbios-0.13.6";
  src = fetchurl {
    url = http://linux.dell.com/libsmbios/download/libsmbios/libsmbios-0.13.6/libsmbios-0.13.6.tar.gz;
    sha256 = "0zjch3xzyr289x64wzaj67l4jj0x645krxmx4yqn18hp2innfffs";
  };
  buildInputs = [libxml2];
  configureFlags = "--disable-static"; # bloated enough as it is...

  # `make install' forgets to install the header files.
  postInstall = "
    ensureDir $out/include
    cp -prvd include/smbios $out/include/
  ";
}
