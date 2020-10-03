{ stdenv
, fetchFromGitLab
, lib
, darwin
, git
, nettle
# Use the same llvmPackages version as Rust
, llvmPackages_10
, cargo
, rustc
, rustPlatform
, pkg-config
, glib
, openssl
, sqlite
, capnproto
, ensureNewerSourcesForZipFilesHook
, pythonSupport ? true
, pythonPackages ? null
}:

assert pythonSupport -> pythonPackages != null;

rustPlatform.buildRustPackage rec {
  pname = "sequoia";
  version = "0.19.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia";
    rev = "v${version}";
    sha256 = "1870wd03c3x0da9p3jmkvfx8am87ak0dcsvp2qkjvglbl396kd8y";
  };

  cargoSha256 = "0bb51vdppdjhsxbfy3lyqvw5r5j58r3wi0qb68m2a45k3za7liss";

  nativeBuildInputs = [
    pkg-config
    cargo
    rustc
    git
    llvmPackages_10.libclang
    llvmPackages_10.clang
    ensureNewerSourcesForZipFilesHook
    capnproto
  ] ++
    lib.optionals pythonSupport [ pythonPackages.setuptools ]
  ;

  checkInputs = lib.optionals pythonSupport [
    pythonPackages.pytest
    pythonPackages.pytestrunner
  ];

  buildInputs = [
    openssl
    sqlite
    nettle
  ] ++ lib.optionals pythonSupport [ pythonPackages.python pythonPackages.cffi ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ]
  ;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  buildFlags = [
    "build-release"
  ];

  LIBCLANG_PATH = "${llvmPackages_10.libclang}/lib";

  # Sometimes, tests fail on CI (ofborg) & hydra without this
  CARGO_TEST_ARGS = "--workspace --exclude sequoia-store";

  # Without this, the examples won't build
  postPatch = ''
    substituteInPlace openpgp-ffi/examples/Makefile \
      --replace '-O0 -g -Wall -Werror' '-g'
    substituteInPlace ffi/examples/Makefile \
      --replace '-O0 -g -Wall -Werror' '-g'
  '';


  preInstall = lib.optionalString pythonSupport ''
    export installFlags="PYTHONPATH=$PYTHONPATH:$out/${pythonPackages.python.sitePackages}"
  '' + lib.optionalString (!pythonSupport) ''
    export makeFlags="PYTHON=disable"
  '';

  # Don't use buildRustPackage phases, only use it for rust deps setup
  configurePhase = null;
  buildPhase = null;
  doCheck = true;
  checkPhase = null;
  installPhase = null;

  meta = with stdenv.lib; {
    description = "A cool new OpenPGP implementation";
    homepage = "https://sequoia-pgp.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ minijackson doronbehar ];
    broken = stdenv.targetPlatform.isDarwin;
  };
}
