{ stdenv, fetchFromGitHub, pkgconfig, postgresql }:

stdenv.mkDerivation rec {
  name = "tsearch-extras-${version}";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "zulip";
    repo = "tsearch_extras";
    rev = version;
    sha256 = "0i3i99lw80jwd4xflgdqabxmn1dnm1gm7dzf1mqv2drllxcy3yix";
  };

  nativenativeBuildInputs = [ pkgconfig ];
  buildInputs = [ postgresql ];

  installPhase = ''
    mkdir -p $out/bin
    install -D tsearch_extras.so -t $out/lib/
    install -D ./{tsearch_extras--1.0.sql,tsearch_extras.control} -t $out/share/extension
  '';

  meta = with stdenv.lib; {
    description = "Provides a few PostgreSQL functions for a lower-level data full text search";
    homepage = https://github.com/zulip/tsearch_extras/;
    license = licenses.postgresql;
    maintainers = with maintainers; [ DerTim1 ];
  };
}
