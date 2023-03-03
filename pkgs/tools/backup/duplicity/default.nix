{ lib, stdenv
, fetchFromGitLab
, fetchpatch
, python3
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
  pythonPackages = python3.pkgs;
  inherit (lib.versions) majorMinor splitVersion;
  majorMinorPatch = v: builtins.concatStringsSep "." (lib.take 3 (splitVersion v));
in
pythonPackages.buildPythonApplication rec {
  pname = "duplicity";
  version = "0.8.23";

  src = fetchFromGitLab {
    owner = "duplicity";
    repo = "duplicity";
    rev = "rel.${version}";
    sha256 = "0my015zc8751smjgbsysmca7hvdm96cjw5zilqn3zq971nmmrksb";
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

  preConfigure = ''
    # fix version displayed by duplicity --version
    # see SourceCopy in setup.py
    ls
    for i in bin/*.1 duplicity/__init__.py; do
      substituteInPlace "$i" --replace '$version' "${version}"
    done
  '';

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
    boto3
    cffi
    cryptography
    ecdsa
    idna
    pygobject3
    fasteners
    lockfile
    paramiko
    pyasn1
    pycrypto
    pydrive2
    future
  ];

  nativeCheckInputs = [
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
    pytest-runner
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

    # check version string
    duplicity --version | grep ${version}
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
    homepage = "https://duplicity.gitlab.io/duplicity-web/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
