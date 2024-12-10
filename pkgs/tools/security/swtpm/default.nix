{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libtasn1,
  openssl,
  fuse,
  glib,
  libseccomp,
  json-glib,
  libtpms,
  unixtools,
  expect,
  socat,
  gnutls,
  perl,

  # Tests
  python3,
  which,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swtpm";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "stefanberger";
    repo = "swtpm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-48/BOzGPoKr/BGEXFo3FXWr6ZoPB+ixZIvv78g6L294=";
  };

  nativeBuildInputs = [
    pkg-config
    unixtools.netstat
    expect
    socat
    perl # for pod2man
    python3
    autoreconfHook
  ];

  nativeCheckInputs = [
    which
  ];

  buildInputs =
    [
      libtpms
      openssl
      libtasn1
      glib
      json-glib
      gnutls
    ]
    ++ lib.optionals stdenv.isLinux [
      fuse
      libseccomp
    ];

  configureFlags =
    [
      "--localstatedir=/var"
    ]
    ++ lib.optionals stdenv.isLinux [
      "--with-cuse"
    ];

  postPatch = ''
    patchShebangs tests/*

    # Makefile tries to create the directory /var/lib/swtpm-localca, which fails
    substituteInPlace samples/Makefile.am \
        --replace 'install-data-local:' 'do-not-execute:'

    # Use the correct path to the certtool binary
    # instead of relying on it being in the environment
    substituteInPlace src/swtpm_localca/swtpm_localca.c \
      --replace \
        '# define CERTTOOL_NAME "gnutls-certtool"' \
        '# define CERTTOOL_NAME "${gnutls}/bin/certtool"' \
      --replace \
        '# define CERTTOOL_NAME "certtool"' \
        '# define CERTTOOL_NAME "${gnutls}/bin/certtool"'

    substituteInPlace tests/common --replace \
        'CERTTOOL=gnutls-certtool;;' \
        'CERTTOOL=certtool;;'

    # Fix error on macOS:
    # stat: invalid option -- '%'
    # This is caused by the stat program not being the BSD version,
    # as is expected by the test
    substituteInPlace tests/common --replace \
        'if [[ "$(uname -s)" =~ (Linux|CYGWIN_NT-) ]]; then' \
        'if [[ "$(uname -s)" =~ (Linux|Darwin|CYGWIN_NT-) ]]; then'

    # Otherwise certtool seems to pick up the system language on macOS,
    # which might cause a test to fail
    substituteInPlace tests/test_swtpm_setup_create_cert --replace \
        '$CERTTOOL' \
        'LC_ALL=C.UTF-8 $CERTTOOL'
  '';

  doCheck = true;
  enableParallelBuilding = true;

  outputs = [
    "out"
    "man"
  ];

  passthru.tests = { inherit (nixosTests) systemd-cryptenroll; };

  meta = with lib; {
    description = "Libtpms-based TPM emulator";
    homepage = "https://github.com/stefanberger/swtpm";
    license = licenses.bsd3;
    maintainers = [ maintainers.baloo ];
    mainProgram = "swtpm";
    platforms = platforms.all;
  };
})
