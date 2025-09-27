{ lib, stdenv
, fetchFromGitHub
, asciidoctor, ditaa, graphviz
, gitMinimal
, erlang
, jdk
, rsync
, rouge
}:

stdenv.mkDerivation rec {
  pname = "the-beam-book";
  version = "latest";

  src = fetchFromGitHub {
    owner = "happi";
    repo = "theBeamBook";
    rev = version;
    sha256 = "18jfxx6n8d13fhxgfv4978iwdf73gazh8j013dw0ygpdl1v6gk6b";
    leaveDotGit = true;
  };

  postUnpack = ''
    cp ${erlang.src}/lib/compiler/src/genop.tab $sourceRoot/
  '';

  sourceRoot = "source";

  patches = [
    # Cannot call wget in build environment. File is fetched during unpackPhase
    ./remove-wget.patch
  ];

  postPatch = ''
    patchShebangs ./bin/gitlog.sh
  '';

  dontConfigure = true;

  preBuild = ''
    mkdir -p $sourceRoot/chapters
  '';

  nativeBuildInputs = [
    asciidoctor
    # asciidoctor: FAILED: 'asciidoctor-diagram' could not be loaded
    ditaa
    graphviz
    rouge
    erlang
    jdk
    gitMinimal
    rsync
  ];

  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/beam-book
    cp -r site/* $out/
    cp -r beam-book.pdf $out/share/beam-book/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/happi/theBeamBook";
    license = licenses.cc-by-40;
    description = "A description of the Erlang Runtime System ERTS and the virtual Machine BEAM";
    maintainers = with maintainers; [ KarlJoad ];
  };
}
