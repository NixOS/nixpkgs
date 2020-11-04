{ stdenv, fetchFromGitHub, libuv, lz4, zlib }:

stdenv.mkDerivation rec {
  pname = "maxcso";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "unknownbrackets";
    repo = "maxcso";
    rev = "v${version}";
    sha256 = "10r0vb3ndpq1pw5224d48nim5xz8jj94zhlfy29br6h6jblq8zap";
  };

  buildInputs = [ libuv lz4 zlib ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/unknownbrackets/maxcso";
    description =
      "A fast ISO to CSO compression program for use with PSP and PS2 emulators, which uses multiple algorithms for best compression ratio";
    maintainers = with maintainers; [ david-sawatzke ];
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.isc;
  };
}
