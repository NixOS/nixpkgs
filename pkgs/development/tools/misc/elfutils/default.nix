{stdenv, fetchurl, zlib, bzip2, xz, m4}:

# TODO: Look at the hardcoded paths to kernel, modules etc.
stdenv.mkDerivation rec {
  name = "elfutils-${version}";
  version = "0.152";
  
  src = fetchurl {
    urls = [
      "https://fedorahosted.org/releases/e/l/elfutils/${version}/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "19mlgxyzcwiv64ynj2cibgkiw4qkm3n37kizvy6555dsmlaqfybq";
  };

  buildInputs = [ zlib bzip2 xz ];

  buildNativeInputs = [m4];
  
  dontAddDisableDepTrack = true;

  meta = {
    homepage = https://fedorahosted.org/elfutils/;
  };
}
