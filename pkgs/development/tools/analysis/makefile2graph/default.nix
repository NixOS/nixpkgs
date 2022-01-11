{ lib, stdenv, fetchFromGitHub, makeWrapper, bash, gnumake }:

stdenv.mkDerivation rec {
  pname = "makefile2graph";
  version = "unstable-2018-01-03";

  src = fetchFromGitHub {
    owner = "lindenb";
    repo = "makefile2graph";
    rev = "61fb95a5ba91c20236f5e4deb11127c34b47091f";
    sha256 = "07hq40bl48i8ka35fcciqcafpd8k9rby1wf4vl2p53v0665xaghr";
  };

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [ "prefix=$(out)" ];

  fixupPhase = ''
    substituteInPlace $out/bin/makefile2graph \
      --replace '/bin/sh' ${bash}/bin/bash \
      --replace 'make2graph' "$out/bin/make2graph"
    wrapProgram $out/bin/makefile2graph \
      --set PATH ${lib.makeBinPath [ gnumake ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/lindenb/makefile2graph";
    description = "Creates a graph of dependencies from GNU-Make; Output is a graphiz-dot file or a Gexf-XML file";
    maintainers = with maintainers; [ cmcdragonkai ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
