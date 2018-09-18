{ stdenv, fetchFromGitHub, ocamlPackages, makeWrapper, writeScript
, dune, python3, rsync, fetchpatch }:
let
  # Manually set version - the setup script requires
  # hg and git + keeping the .git directory around.
  pyre-version = "0.0.11";
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

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyre-check";
    rev = "v${pyre-version}";
    sha256 = "0ig7bx2kfn2kbxw74wysh5365yp5gyby42l9l29iclrzdghgk32l";
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
    dune
    ounit
    # python36Packages.python36Full # TODO
  ];

  buildPhase = ''
    # build requires HOME to be set
    export HOME=.

    # "external" because https://github.com/facebook/pyre-check/pull/8/files
    cp Makefile.template Makefile
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
    platforms = with platforms; linux;
    maintainers = with maintainers; [ teh ];
  };
};
typeshed = stdenv.mkDerivation {
  name = "typeshed";
  # typeshed doesn't have versions, it seems to be synchronized with
  # mypy relases. I'm assigning a random version here (same as pyre).
  version = pyre-version;
  src = fetchFromGitHub {
    owner = "python";
    repo = "typeshed";
    rev = "a08c6ea";
    sha256 = "0wy8yh43vhyyc4g7iqnmlj66kz5in02y5qc0c4jdckhpa3mchaqk";
  };
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = "cp -r $src $out";
};
in python3.pkgs.buildPythonApplication rec {
  pname = "pyre-check";
  version = pyre-version;
  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyre-check";
    rev = "v${pyre-version}";
    sha256 = "0ig7bx2kfn2kbxw74wysh5365yp5gyby42l9l29iclrzdghgk32l";
  };
  patches = [
    (fetchpatch {
      url = "https://github.com/facebook/pyre-check/commit/b473d2ed9fc11e7c1cd0c7b8c42f521e5cdc2003.patch";
      sha256 = "05xvyp7j4n6z92bxf64rxfq5pvaadxgx1c8c5qziy75vdz72lkcy";
    })
    ./pyre-bdist-wheel.patch
  ];

  # The build-pypi-package script does some funky stuff with build
  # directories - easier to patch it a bit than to replace it
  # completely though:
  postPatch = ''
    mkdir ./build
    substituteInPlace scripts/build-pypi-package.sh \
        --replace 'NIX_BINARY_FILE' '${pyre-bin}/bin/pyre.bin' \
        --replace 'BUILD_ROOT="$(mktemp -d)"' "BUILD_ROOT=$(pwd)/build"
  '';

  buildInputs = [ pyre-bin rsync ];
  propagatedBuildInputs = with python3.pkgs; [ docutils typeshed ];
  buildPhase = ''
    bash scripts/build-pypi-package.sh --version ${pyre-version} --bundle-typeshed ${typeshed}
    cp -r build/dist dist
  '';

  doCheck = false; # can't open file 'nix_run_setup':
}
