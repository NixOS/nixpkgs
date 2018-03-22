{ stdenv, fetchFromGitHub, pkgconfig, postgresql }:

stdenv.mkDerivation rec {
  name = "tsearch-extras-${version}";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "zulip";
    repo = "tsearch_extras";
    rev = version;
    sha256 = "1ivg9zn7f1ks31ixxwywifwhzxn6py8s5ky1djyxnb0s60zckfjg";
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
