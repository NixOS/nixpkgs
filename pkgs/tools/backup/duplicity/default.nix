{ lib, stdenv
, fetchurl
, pythonPackages
, librsync
, ncftp
, gnupg
, gnutar
, par2cmdline
, util-linux
, rsync
, makeWrapper
, gettext
}:
let
  inherit (lib.versions) majorMinor splitVersion;
  majorMinorPatch = v: builtins.concatStringsSep "." (lib.take 3 (splitVersion v));
in
pythonPackages.buildPythonApplication rec {
  pname = "duplicity";
  version = "0.8.17";

  src = fetchurl {
    url = "https://code.launchpad.net/duplicity/${majorMinor version}-series/${majorMinorPatch version}/+download/duplicity-${version}.tar.gz";
    sha256 = "114rwkf9b3h4fcagrx013sb7krc4hafbwl9gawjph2wd9pkv2wx2";
  };

  patches = [
    # We use the tar binary on all platforms.
    ./gnutar-in-test.patch

    # Our Python infrastructure runs test in installCheckPhase so we need
    # to make the testing code stop assuming it is run from the source directory.
    ./use-installed-scripts-in-test.patch
  ] ++ lib.optionals stdenv.isLinux [
    # Broken on Linux in Nix' build environment
    ./linux-disable-timezone-test.patch
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    makeWrapper
    gettext
    pythonPackages.wrapPython
    pythonPackages.setuptools-scm
  ];
  buildInputs = [
    librsync
  ];

  pythonPath = with pythonPackages; [
    b2sdk
    boto
    boto3
    cffi
    cryptography
    ecdsa
    idna
    pygobject3
    fasteners
    ipaddress
    lockfile
    paramiko
    pyasn1
    pycrypto
    pydrive
    future
  ] ++ lib.optionals (!isPy3k) [
    enum
  ];

  checkInputs = [
    gnupg # Add 'gpg' to PATH.
    gnutar # Add 'tar' to PATH.
    librsync # Add 'rdiff' to PATH.
    par2cmdline # Add 'par2' to PATH.
  ] ++ lib.optionals stdenv.isLinux [
    util-linux # Add 'setsid' to PATH.
  ] ++ (with pythonPackages; [
    lockfile
    mock
    pexpect
    pytest
    pytestrunner
  ]);

  postInstall = ''
    wrapProgram $out/bin/duplicity \
      --prefix PATH : "${lib.makeBinPath [ gnupg ncftp rsync ]}"
  '';

  preCheck = ''
    wrapPythonProgramsIn "$PWD/testing/overrides/bin" "$pythonPath"

    # Add 'duplicity' to PATH for tests.
    # Normally, 'setup.py test' adds 'build/scripts-2.7/' to PATH before running
    # tests. However, 'build/scripts-2.7/duplicity' is not wrapped, so its
    # shebang is incorrect and it fails to run inside Nix' sandbox.
    # In combination with use-installed-scripts-in-test.patch, make 'setup.py
    # test' use the installed 'duplicity' instead.
    PATH="$out/bin:$PATH"

    # Don't run developer-only checks (pep8, etc.).
    export RUN_CODE_TESTS=0
  '' + lib.optionalString stdenv.isDarwin ''
    # Work around the following error when running tests:
    # > Max open files of 256 is too low, should be >= 1024.
    # > Use 'ulimit -n 1024' or higher to correct.
    ulimit -n 1024
  '';

  # TODO: Fix test failures on macOS 10.13:
  #
  # > OSError: out of pty devices
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Encrypted bandwidth-efficient backup using the rsync algorithm";
    homepage = "https://www.nongnu.org/duplicity";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peti ];
    platforms = platforms.unix;
  };
}
