{ stdenv, fetchurl, yacc, lzo, db4 }:

stdenv.mkDerivation rec {
  name = "netboot-0.10.2";
  src = fetchurl {
    url = "mirror://sourceforge/netboot/${name}.tar.gz";
    sha256 = "09w09bvwgb0xzn8hjz5rhi3aibysdadbg693ahn8rylnqfq4hwg0";
  };

  buildInputs = [ yacc lzo db4 ];

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "Mini PXE server";
    maintainers = [ maintainers.raskin ];
    platforms = ["x86_64-linux"];
    license = stdenv.lib.licenses.free;
  };
}
