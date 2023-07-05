{lib, stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  pname = "redo";
  version = "1.4";
  src = fetchurl {
    url = "https://jdebp.eu./Repository/freebsd/${pname}-${version}.tar.gz";
    sha256 = "1c8gr5h77v4fw78zkhbm9z9adqs3kd7xvxwnmci2zvlf4bqqk4jv";
  };

  nativeBuildInputs = [ perl /* for pod2man */ ];

  sourceRoot = ".";

  buildPhase = ''
    ./package/compile
  '';
  installPhase = ''
    ./package/export $out/
  '';

  meta = {
    homepage = "https://jdebp.eu./Softwares/redo/";
    description = "A system for building target files from source files";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vrthra ];
    platforms = lib.platforms.unix;
  };
}
