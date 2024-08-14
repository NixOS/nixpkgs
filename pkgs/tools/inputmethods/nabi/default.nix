{ lib, stdenv, fetchurl, pkg-config, gtk2, libhangul }:

stdenv.mkDerivation rec {
  pname = "nabi";
  version = "1.0.0";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/nabi/nabi-${version}.tar.gz";
    sha256 = "0craa24pw7b70sh253arv9bg9sy4q3mhsjwfss3bnv5nf0xwnncw";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 libhangul ];

  meta = with lib; {
    description = "Easy Hangul XIM";
    mainProgram = "nabi";
    homepage = "https://github.com/choehwanjin/nabi";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.ianwookim ];
    platforms = platforms.linux;
  };
}
