{ stdenv, fetchFromGitLab, lib, darwin
, git, nettle, llvmPackages, cargo, rustc
, rustPlatform, pkgconfig, glib
, openssl, sqlite, capnproto
, ensureNewerSourcesForZipFilesHook, pythonSupport ? true, pythonPackages ? null
}:

assert pythonSupport -> pythonPackages != null;

rustPlatform.buildRustPackage rec {
  pname = "sequoia";
  version = "0.10.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gvczghyik56jlnb8cz7jg2l3nbm519gf19g7l5blxci3009v23d";
  };

  cargoSha256 = "0dk9sjcbmygbdpwqnah5krli1p9j5hahgiqrca9c0kfpfiwgx62q";

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
    broken = true;
  };
}
