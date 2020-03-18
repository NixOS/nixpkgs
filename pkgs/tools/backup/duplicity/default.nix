{ stdenv
, fetchpatch
, fetchurl
, pythonPackages
, librsync
, ncftp
, gnupg
, gnutar
, par2cmdline
, utillinux
, rsync
, backblaze-b2
, makeWrapper
, gettext
}:
let
  inherit (stdenv.lib.versions) majorMinor splitVersion;
  majorMinorPatch = v: builtins.concatStringsSep "." (stdenv.lib.take 3 (splitVersion v));
in
pythonPackages.buildPythonApplication rec {
  pname = "duplicity";
  version = "0.8.11.1596";

  src = fetchurl {
    url = "https://code.launchpad.net/duplicity/${majorMinor version}-series/${majorMinorPatch version}/+download/duplicity-${version}.tar.gz";
    sha256 = "1qdaaybwdc13nfwnwrqij4lc23iwy73lyqn5lb4iznq6axp6m0h9";
  };

  patches = [
    # We use the tar binary on all platforms.
    ./gnutar-in-test.patch

    # Our Python infrastructure runs test in installCheckPhase so we need
    # to make the testing code stop assuming it is run from the source directory.
    ./use-installed-scripts-in-test.patch
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    ./linux-disable-timezone-test.patch
  ];

  nativeBuildInputs = [
    makeWrapper
    gettext
    pythonPackages.wrapPython
  ];
  buildInputs = [
    librsync
  ];

  propagatedBuildInputs = [
    backblaze-b2
  ] ++ (with pythonPackages; [
    boto
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
  ] ++ stdenv.lib.optionals (!isPy3k) [
    enum
  ]);

  checkInputs = [
    gnupg # Add 'gpg' to PATH.
    gnutar # Add 'tar' to PATH.
    librsync # Add 'rdiff' to PATH.
    par2cmdline # Add 'par2' to PATH.
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    utillinux # Add 'setsid' to PATH.
  ] ++ (with pythonPackages; [
    lockfile
    mock
    pexpect
    pytest
    pytestrunner
  ]);

  postInstall = ''
    wrapProgram $out/bin/duplicity \
      --prefix PATH : "${stdenv.lib.makeBinPath [ gnupg ncftp rsync ]}"
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
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    # Work around the following error when running tests:
    # > Max open files of 256 is too low, should be >= 1024.
    # > Use 'ulimit -n 1024' or higher to correct.
    ulimit -n 1024
  '';

  # TODO: Fix test failures on macOS 10.13:
  #
  # > OSError: out of pty devices
  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    description = "Encrypted bandwidth-efficient backup using the rsync algorithm";
    homepage = "https://www.nongnu.org/duplicity";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peti ];
    platforms = platforms.unix;
  };
}
