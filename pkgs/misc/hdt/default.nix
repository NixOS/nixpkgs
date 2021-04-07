{ lib, stdenv, fetchFromGitHub, autoreconfHook, libtool, pkg-config, zlib, serd }:

stdenv.mkDerivation rec {
  pname = "hdt";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "rdfhdt";
    repo = "hdt-cpp";
    rev = "v${version}";
    sha256 = "1vsq80jnix6cy78ayag7v8ajyw7h8dqyad1q6xkf2hzz3skvr34z";
  };

  buildInputs = [ zlib serd ];

  nativeBuildInputs = [ autoreconfHook libtool pkg-config ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://www.rdfhdt.org/";
    description = "Header Dictionary Triples (HDT) is a compression format for RDF data that can also be queried for Triple Patterns";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.koslambrou ];
  };
}
