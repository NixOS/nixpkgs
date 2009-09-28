{ stdenv, fetchurl, pkgconfig, libxml2, perl }:

stdenv.mkDerivation rec {
  name = "libsmbios-2.2.19";

  src = fetchurl {
    url = "http://linux.dell.com/libsmbios/download/libsmbios/${name}/${name}.tar.gz";
    sha256 = "0f4wnjml734ssg583r448ypax7vf3f9n8gybzvzg170lc3byayhv";
  };
  
  buildInputs = [ pkgconfig libxml2 perl ];

  # It tries to install some Python stuff even when Python is disabled.
  installFlags = "pkgpythondir=$(TMPDIR)/python";

  # It forgets to install headers.
  postInstall =
    ''
      cp -a src/include/* $out/include
      cp -a out/public-include/* $out/include
    ''; # */

  meta = {
    homepage = http://linux.dell.com/libsmbios/main/index.html;
    description = "A library to obtain BIOS information";
    license = "GPLv2+"; # alternatively, under the Open Software License version 2.1
  };
}
