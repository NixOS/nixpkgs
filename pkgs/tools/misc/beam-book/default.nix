{ lib, stdenv
, fetchFromGitHub
, wget, asciidoctor, ditaa, graphviz
, gitMinimal
, erlang
, jdk
, rsync
, rouge
}:

let
  pname = "the-beam-book";
  version = "0.0.14.fix";

  bookDirName = "${pname}-${version}";

  book = fetchFromGitHub {
    name = bookDirName;
    owner = "happi";
    repo = "theBeamBook";
    rev = version;
    sha256 = "06r19063a9s6hg84garn83rn4cnnkvs58x3j68zvf94mwsmfs86h";
    leaveDotGit = true;
  };

  erlangGenOp = fetchFromGitHub {
    name = "erlang.tar.gz";
    owner = "erlang";
    repo = "otp";
    rev = "master";
    sha256 = "1qfdry8wdba3abfsa1qkkcglww186j8dyl40si1vrwsc7f221r1d";
  };

in stdenv.mkDerivation rec {
  inherit pname version;

  srcs = [ book erlangGenOp ];

  outputs = [ "out" "pdf" ];

  sourceRoot = bookDirName;

  postUnpack = ''
    cp ${erlangGenOp}/lib/compiler/src/genop.tab ${bookDirName}/
  '';

  patches = [
    # Cannot call wget in build environment. File is fetched during unpackPhase
    ./remove-wget.patch

    # bin/gitlog.sh script calls `git shortlog` without commit parameter, which
    # is problematic in non-interactive shell sessions.
    # https://stackoverflow.com/a/43042363
    ./add-HEAD-to-git-shortlog.patch
  ];

  # Patch shebangs after we apply all patches
  postPatch = ''
    patchShebangs .
  '';

  dontConfigure = true;

  preBuild = ''
    mkdir -p $sourceRoot/chapters
  '';

  nativeBuildInputs = [
    wget
    asciidoctor
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
    mkdir -p $out
    mkdir -p $pdf
    cp -r site/* $out/
    cp -r beam-book.pdf $pdf/
    ln -s -T "$pdf/beam-book.pdf" "$out/beam-book.pdf"
  '';

  meta = with lib; {
    homepage = "https://github.com/happi/theBeamBook";
    license = licenses.cc-by-40;
    description = "A description of the Erlang Runtime System ERTS and the virtual Machine BEAM";
    maintainers = with maintainers; [ KarlJoad ];
    outputsToInstall = [ "out" "pdf" ];
  };

}
