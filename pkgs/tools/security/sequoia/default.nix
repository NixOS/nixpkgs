{ stdenv
, fetchFromGitLab
, fetchpatch
, lib
, darwin
, git
, nettle
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
  version = "0.27.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia";
    rev = "sq/v${version}";
    sha256 = "sha256-KhJAXpj47Tvds5SLYwnsNeIlPf9QEopoCzsvvHgCwaI=";
  };

  cargoSha256 = "sha256-Y7iiZVIT9Vbe4YmTfGTU8p3H3odQKms2FBnnWgvF7mI=";

  patches = [
    (fetchpatch
      { url = "https://gitlab.com/sequoia-pgp/sequoia/-/commit/7916f90421ecb9a75e32f0284459bcc9a3fd02b0.patch";
        sha256 = "sha256-KBBn6XaGzIT0iVzoCYsS0N+OkZzGuWmUmIF2hl49FEI=";
      }
    )
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

  meta = with lib; {
    description = "A cool new OpenPGP implementation";
    homepage = "https://sequoia-pgp.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ minijackson doronbehar ];
    mainProgram = "sq";
  };
}
