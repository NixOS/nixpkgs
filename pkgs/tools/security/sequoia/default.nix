{ stdenv
, fetchFromGitLab
, fetchpatch
, lib
, darwin
, git
, nettle
, nix-update-script
# Use the same llvmPackages version as Rust
, llvmPackages_12
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
  version = "0.28.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia";
    rev = "sq/v${version}";
    hash = "sha256-T7WOYMqyBeVHs+4w8El99t0NTUKqMW1QeAkNGKcaWr0=";
  };

  cargoHash = "sha256-zaAAEFBumfHU4hGzAOmLvBu3X4J7LAlmexqixHtVPr8=";

  patches = [
    (fetchpatch {
      url = "https://gitlab.com/sequoia-pgp/sequoia/-/commit/4dc6e624c2394936dc447f18aedb4a4810bb2ddb.patch";
      hash = "sha256-T6hh7U1gvKvyn/OCuJBvLM7TG1VFnpvpAiWS72m3P6I=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cargo
    rustc
    git
    llvmPackages_12.libclang.lib
    llvmPackages_12.clang
    ensureNewerSourcesForZipFilesHook
    capnproto
  ] ++
    lib.optionals pythonSupport [ pythonPackages.setuptools ]
  ;

  nativeCheckInputs = lib.optionals pythonSupport [
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

  LIBCLANG_PATH = "${llvmPackages_12.libclang.lib}/lib";

  # Sometimes, tests fail on CI (ofborg) & hydra without this
  checkFlags = [
    # doctest for sequoia-ipc fail for some reason
    "--skip=macros::assert_send_and_sync"
    "--skip=macros::time_it"
  ];

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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A cool new OpenPGP implementation";
    homepage = "https://sequoia-pgp.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ minijackson doronbehar ];
    mainProgram = "sq";
  };
}
