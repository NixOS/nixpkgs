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
  # Upstream has separate version numbering for the library and the CLI frontend.
  # This derivation provides the CLI frontend, and thus uses its version number.
  version = "0.26.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia";
    rev = "sq/v${version}";
    sha256 = "1rcbv1s7wpxhrzw082q6vfrq1ja2ssfxn53c90h8fh5wrj7ns751";
  };

  cargoSha256 = "0f3b8rh4pl03n8j9ihazaak214sv1rsksbgrb1nfcy8sq2yqfj4g";

  nativeBuildInputs = [
    pkg-config
    cargo
    rustc
    git
    llvmPackages_10.libclang.lib
    llvmPackages_10.clang
    ensureNewerSourcesForZipFilesHook
    capnproto
  ] ++
    lib.optionals pythonSupport [ pythonPackages.setuptools ]
  ;

  checkInputs = lib.optionals pythonSupport [
    pythonPackages.pytest
    pythonPackages.pytest-runner
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
    # Defaults to "ginstall" from some reason, although upstream's Makefiles check uname
    "INSTALL=install"
  ];

  buildFlags = [
    "build-release"
  ];

  LIBCLANG_PATH = "${llvmPackages_10.libclang.lib}/lib";

  # Sometimes, tests fail on CI (ofborg) & hydra without this
  CARGO_TEST_ARGS = "--workspace --exclude sequoia-store";

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

  meta = with lib; {
    description = "A cool new OpenPGP implementation";
    homepage = "https://sequoia-pgp.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ minijackson doronbehar ];
  };
}
