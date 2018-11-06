{ stdenv, fetchFromGitHub, ocamlPackages, makeWrapper, writeScript
, dune, python3, rsync, fetchpatch, buck }:
let
  # Manually set version - the setup script requires
  # hg and git + keeping the .git directory around.
  pyre-version = "0.0.17";  # also change typeshed revision below with $pyre-src/.typeshed-version
  pyre-src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyre-check";
    rev = "v${pyre-version}";
    sha256 = "0y86a3g5xbgh0byksyx5jw7yq7w840x85dhz9inz6mkg5j06mcis";
  };
  versionFile = writeScript "version.ml" ''
    cat > "./version.ml" <<EOF
    open Core
    let build_info () =
    "pyre-nixpkgs ${pyre-version}"
    let version () =
    "${pyre-version}"

    let log_version_banner () =
      Log.info "Running as pid: %d" (Pid.to_int (Unix.getpid ()));
      Log.info "Version: %s" (version ());
    EOF
  '';
 pyre-bin = stdenv.mkDerivation {
  name = "pyre-${pyre-version}";

  src = pyre-src;

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
    dune
    ounit
    # python36Packages.python36Full # TODO
  ];

  buildPhase = ''
    # build requires HOME to be set
    export HOME=.

    # "external" because https://github.com/facebook/pyre-check/pull/8/files
    sed "s/%VERSION%/external/" dune.in > dune

    cp ${versionFile} ./scripts/generate-version-number.sh

    mkdir $(pwd)/build
    export OCAMLFIND_DESTDIR=$(pwd)/build
    export OCAMLPATH=$OCAMLPATH:$(pwd)/build

    make release
  '';

  checkPhase = ''
    make test
    # ./scripts/run-python-tests.sh # TODO: once typeshed and python bits are added
  '';

  # Note that we're not installing the typeshed yet.
  # Improvement for a future version.
  installPhase = ''
    mkdir -p $out/bin
    cp ./_build/default/main.exe $out/bin/pyre.bin
  '';

  meta = with stdenv.lib; {
    description = "A performant type-checker for Python 3";
    homepage = https://pyre-check.org;
    license = licenses.mit;
    platforms = ocamlPackages.ocaml.meta.platforms;
    maintainers = with maintainers; [ teh ];
  };
};
typeshed = stdenv.mkDerivation {
  pname = "typeshed";
  version = pyre-version;
  src = fetchFromGitHub {
    owner = "python";
    repo = "typeshed";
    rev = "bc3f9fe1d3c43b00c04cedb23e0eeebc9e1734b6";
    sha256 = "06b2kj4n49h4sgi8hn5kalmir8llhanfdc7f1924cxvrkj5ry94b";
  };
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = "cp -r $src $out";
};
in python3.pkgs.buildPythonApplication rec {
  pname = "pyre-check";
  version = pyre-version;
  src = pyre-src;
  patches = [ ./pyre-bdist-wheel.patch ];

  # The build-pypi-package script does some funky stuff with build
  # directories - easier to patch it a bit than to replace it
  # completely though:
  postPatch = ''
    mkdir ./build
    substituteInPlace scripts/build-pypi-package.sh \
        --replace 'NIX_BINARY_FILE' '${pyre-bin}/bin/pyre.bin' \
        --replace 'BUILD_ROOT="$(mktemp -d)"' "BUILD_ROOT=$PWD/build"
    substituteInPlace client/buck.py \
        --replace '"buck"' '"${buck}/bin/buck"'
    substituteInPlace client/tests/buck_test.py \
        --replace '"buck"' '"${buck}/bin/buck"'
  '';

  buildInputs = [ pyre-bin ];
  nativeBuildInputs = [ rsync ]; # only required for build-pypi-package.sh
  propagatedBuildInputs = with python3.pkgs; [ docutils typeshed ];
  buildPhase = ''
    bash scripts/build-pypi-package.sh --version ${pyre-version} --bundle-typeshed ${typeshed}
    cp -r build/dist dist
  '';
  checkPhase = ''
    bash scripts/run-python-tests.sh
  '';
}
