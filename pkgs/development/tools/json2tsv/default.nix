{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "json2tsv";
  version = "1.0";

  src = fetchurl {
    url = "https://codemadness.org/releases/json2tsv/json2tsv-${version}.tar.gz";
    hash = "sha256-BOamDWszYDqKGdKOlAOLY7F9ScZaBJXNdhz38iYW3ps=";
  };

  postPatch = ''
    substituteInPlace jaq --replace "json2tsv" "$out/bin/json2tsv"
  '';

  makeFlags = [ "RANLIB:=$(RANLIB)" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "JSON to TSV converter";
    homepage = "https://codemadness.org/json2tsv.html";
    license = licenses.isc;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
