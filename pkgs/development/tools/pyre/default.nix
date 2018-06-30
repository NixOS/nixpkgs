{ stdenv, fetchFromGitHub, ocamlPackages, makeWrapper, writeScript }:
let
  # Manually set version - the setup script requires
  # hg and git + keeping the .git directory around.
  version = "0.0.8";
  versionFile = writeScript "version.ml" ''
    cat > "./version.ml" <<EOF
    let build_info () =
    "pyre-nixpkgs ${version}"
    let version () =
    "${version}"
    EOF
  '';
in stdenv.mkDerivation {
  name = "pyre-${version}";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyre-check";
    rev = "v${version}";
    sha256 = "0c4km27xnzsqcqvjqxmqak37x473z6azlbldy7f05ghkms7mchrw";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = with ocamlPackages; [
    ocaml
    findlib
    menhir
    yojson
    core
    sedlex
    ppx_deriving_yojson
    ocamlbuild
    ppxlib
  ];

  buildPhase = ''
    # build requires HOME to be set
    export HOME=.

    # "external" because https://github.com/facebook/pyre-check/pull/8/files
    sed "s/%VERSION%/external ${version}/" Makefile.template > Makefile

    cp ${versionFile} ./scripts/generate-version-number.sh

    mkdir $(pwd)/build
    export OCAMLFIND_DESTDIR=$(pwd)/build
    export OCAMLPATH=$OCAMLPATH:$(pwd)/build
    make release
  '';

  checkPhase = ''
    make test
  '';

  # Note that we're not installing the typeshed yet.
  # Improvement for a future version.
  installPhase = ''
    mkdir -p $out/bin
    cp _build/all/main.native $out/bin/pyre
  '';

  meta = with stdenv.lib; {
    description = "A performant type-checker for Python 3";
    homepage = https://pyre-check.org;
    license = licenses.mit;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ teh ];
  };
}
