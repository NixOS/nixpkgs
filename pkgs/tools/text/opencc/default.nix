{ stdenv, fetchurl, cmake, python }:

stdenv.mkDerivation {
  name = "opencc-1.0.4";
  src = fetchurl {
    url = "https://github.com/BYVoid/OpenCC/archive/ver.1.0.4.tar.gz";
    sha256 = "0553b7461ebd379d118d45d7f40f8a6e272750115bdbc49267595a05ee3481ac";
  };

  buildInputs = [ cmake python ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=OFF"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/BYVoid/OpenCC";
    license = licenses.asl20;
    description = "A project for conversion between Traditional and Simplified Chinese";
    longDescription = ''
      Open Chinese Convert (OpenCC) is an opensource project for conversion between
      Traditional Chinese and Simplified Chinese, supporting character-level conversion,
      phrase-level conversion, variant conversion and regional idioms among Mainland China,
      Taiwan and Hong kong.
    '';
    maintainers = [ maintainers.mingchuan ];
    platforms = platforms.linux;
  };
}
