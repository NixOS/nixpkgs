{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "bibutils-${version}";
  version = "6.6";

  src = fetchurl {
    url = "mirror://sourceforge/bibutils/bibutils_${version}_src.tgz";
    sha256 = "1zqwhjsngnflzdp2nd3762bvmkjq5mal417fly1n2xfgdqpg37ps";
  };

  configureFlags = [ "--dynamic" "--install-dir" "$(out)/bin" "--install-lib" "$(out)/lib" ];
  dontAddPrefix = true;

  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "Bibliography format interconversion";
    longDescription = "The bibutils program set interconverts between various bibliography formats using a common MODS-format XML intermediate. For example, one can convert RIS-format files to Bibtex by doing two transformations: RIS->MODS->Bibtex. By using a common intermediate for N formats, only 2N programs are required and not N²-N. These programs operate on the command line and are styled after standard UNIX-like filters.";
    homepage = https://sourceforge.net/p/bibutils/home/Bibutils/;
    license = licenses.gpl2;
    maintainers = [ maintainers.garrison ];
    platforms = platforms.linux;
  };
}
