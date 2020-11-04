{ stdenv, fetchFromGitHub, cmake, asciidoc, pkg-config, imagemagick }:

stdenv.mkDerivation rec {
  pname = "kimg";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "kimg";
    rev = version;
    sha256 = "00gj420m0jvhgm8kkslw8r69nl7r73bxrh6gqs2mx16ymcpkanpk";
  };

  nativeBuildInputs = [ cmake asciidoc pkg-config ];

  buildInputs = [ imagemagick ];

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage    = "https://knightos.org/";
    description = "Converts image formats supported by ImageMagick to the KnightOS image format";
    license     = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms   = platforms.unix;
  };
}
