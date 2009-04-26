{stdenv, fetchurl, libxml2}:

stdenv.mkDerivation rec {
  name = "libsmbios-2.0.3";
  
  src = fetchurl {
    url = "http://linux.dell.com/libsmbios/download/libsmbios/${name}/${name}.tar.gz";
    sha256 = "1mgabn7r8pzi9f7zb4pvlmfm8jmrz1dcijz6nckvcnzxxi02pv4c";
  };
  
  buildInputs = [libxml2];
  
  meta = {
    homepage = http://linux.dell.com/libsmbios/main/index.html;
    description = "A library to obtain BIOS information";
  };
}
