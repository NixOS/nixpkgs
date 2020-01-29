{ stdenv, fetchFromGitLab, lib, darwin
, git, nettle, llvmPackages, cargo, rustc
, rustPlatform, pkgconfig, glib
, openssl, sqlite, capnproto
, ensureNewerSourcesForZipFilesHook, pythonSupport ? true, pythonPackages ? null
}:

assert pythonSupport -> pythonPackages != null;

rustPlatform.buildRustPackage rec {
  pname = "sequoia";
  version = "0.11.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = pname;
    rev = "v${version}";
    sha256 = "1k0pr3vn77fpfzyvbg7xb4jwm6srsiws9bsd8q7i3hl6j56a880i";
  };

  cargoSha256 = "15bhg7b88rq8p0bn6y5wwv2l42kqb1qyx2s3kw0r0v0wadf823q3";

  nativeBuildInputs = [
    pkgconfig
    cargo
    rustc
    git
    llvmPackages.libclang
    llvmPackages.clang
    ensureNewerSourcesForZipFilesHook
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
    capnproto
  ]
    ++ lib.optionals pythonSupport [ pythonPackages.python pythonPackages.cffi ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ]
  ;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  buildFlags = [
    "build-release"
  ];

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  postPatch = ''
    # otherwise, the check fails because we delete the `.git` in the unpack phase
    substituteInPlace openpgp-ffi/Makefile \
      --replace 'git grep' 'grep -R'
    # Without this, the check fails
    substituteInPlace openpgp-ffi/examples/Makefile \
      --replace '-O0 -g -Wall -Werror' '-g'
    substituteInPlace ffi/examples/Makefile \
      --replace '-O0 -g -Wall -Werror' '-g'
  '';

  preInstall = lib.optionalString pythonSupport ''
    export installFlags="PYTHONPATH=$PYTHONPATH:$out/${pythonPackages.python.sitePackages}"
  '' + lib.optionalString (!pythonSupport) ''
    export installFlags="PYTHON=disable"
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
    platforms = platforms.all;
    broken = stdenv.targetPlatform.isDarwin;
  };
}
