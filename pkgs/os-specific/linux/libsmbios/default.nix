{ stdenv, fetchurl, pkgconfig, libxml2, perl }:

let
  name = "libsmbios-2.2.28";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://linux.dell.com/libsmbios/download/libsmbios/${name}/${name}.tar.gz";
    sha256 = "03m0n834w49acwbf5cf9ync1ksnn2jkwaysvy7584y60qpmngb91";
  };

  buildInputs = [ pkgconfig libxml2 perl ];

  # It tries to install some Python stuff even when Python is disabled.
  installFlags = "pkgpythondir=$(TMPDIR)/python";

  # It forgets to install headers.
  postInstall =
    ''
      cp -va "src/include/"* "$out/include/"
      cp -va "out/public-include/"* "$out/include/"
    '';

  meta = {
    homepage = "http://linux.dell.com/libsmbios/main";
    description = "a library to obtain BIOS information";
    license = stdenv.lib.licenses.gpl2Plus; # alternatively, under the Open Software License version 2.1
    platforms = stdenv.lib.platforms.linux;
  };
}
