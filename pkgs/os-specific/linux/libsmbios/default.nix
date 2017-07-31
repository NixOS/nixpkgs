{ stdenv, fetchurl, pkgconfig, libxml2, perl, autoreconfHook, doxygen }:

let
  version = "2.3.2";
in
stdenv.mkDerivation {
  name = "libsmbios-${version}";

  src = fetchurl {
    url = "https://github.com/dell/libsmbios/archive/v${version}.tar.gz";
    sha256 = "0kvi36jrvhspyyq0pjfdyvzvimdn27fvbdpf429qm3xdmfi78y2j";
  };

  buildInputs = [ pkgconfig libxml2 perl autoreconfHook doxygen ];

  # It tries to install some Python stuff even when Python is disabled.
  installFlags = "pkgpythondir=$(TMPDIR)/python";

  postInstall =
    ''
      mkdir -p $out/include
      cp -va "src/include/"* "$out/include/"
      cp -va "out/public-include/"* "$out/include/"
    '';

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" '';

  meta = {
    homepage = http://linux.dell.com/libsmbios/main;
    description = "A library to obtain BIOS information";
    license = stdenv.lib.licenses.gpl2Plus; # alternatively, under the Open Software License version 2.1
    platforms = stdenv.lib.platforms.linux;
  };
}
