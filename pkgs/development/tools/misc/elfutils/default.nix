{stdenv, fetchurl, m4}:

stdenv.mkDerivation rec {
  name = "elfutils-0.140";
  
  src = fetchurl {
    url = "https://fedorahosted.org/releases/e/l/elfutils/${name}.tar.bz2";
    sha256 = "5479c0a0b50b4a370a2baa0f8e906e7e51c403ce3afe3a4cbc6aea7c34eebffd";
  };

  buildInputs = [m4];
  
  dontAddDisableDepTrack = true;

  meta = {
    homepage = https://fedorahosted.org/elfutils/;
  };
}
