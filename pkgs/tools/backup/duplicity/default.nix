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
}:

pythonPackages.buildPythonApplication rec {
  pname = "duplicity";
  version = "0.8.10";

  src = fetchurl {
    url = "https://code.launchpad.net/duplicity/${stdenv.lib.versions.majorMinor version}-series/${version}/+download/${pname}-${version}fin1558.tar.gz";
    sha256 = "13apmavdc2cx3wxv2ymy97c575hc37xjhpa6b4sds8fkx2vrb0mh";
  };

  patches = [
    # We use the tar binary on all platforms.
    ./gnutar-in-test.patch

    # Make test respect TMPDIR env var.
    # https://bugs.launchpad.net/duplicity/+bug/1862672
    (fetchurl {
      url = "https://launchpadlibrarian.net/464404371/0001-Make-LogTest-respect-TMPDIR-env-variable.patch";
      hash = "sha256-wdy8mMurLhBS0ZTXmlIGGrIkS2gGBDwTp7TRxTSXBGo=";
    })

    # Our Python infrastructure runs test in installCheckPhase so we need
    # to make the testing code stop assuming it is run from the source directory.
    ./use-installed-scripts-in-test.patch
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    ./linux-disable-timezone-test.patch
  ];

  buildInputs = [
    librsync
    makeWrapper
    pythonPackages.wrapPython
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
