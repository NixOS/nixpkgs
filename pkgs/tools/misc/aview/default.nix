{ stdenv, fetchurl, aalib }:

stdenv.mkDerivation rec {
  name = "aview-${version}";
  version = "1.3.0rc1";

  src = fetchurl {
    url = "mirror://sourceforge/aa-project/${name}.tar.gz";
    sha256 = "16gcfi2a7akk1qq8pq2rv9z7vciwr2cfdp8zi2dbdfg8ji0irmj2";
  };

  buildInputs = [ aalib ];

  meta = with stdenv.lib; {
    description = "High quality ascii-art image(pnm) browser and animation(fli/flc) player";
    homepage = http://aa-project.sourceforge.net/aview;
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
