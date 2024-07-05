{ lib
, stdenv
, fetchFromGitLab
, python3
, librsync
, glib
, ncftp
, gnupg
, gnutar
, par2cmdline
, util-linux
, rsync
, makeWrapper
, wrapGAppsNoGuiHook
, gettext
, getconf
, testers
, nix-update-script
}:

let self = python3.pkgs.buildPythonApplication rec {
  pname = "duplicity";
  version = "2.2.3";

  src = fetchFromGitLab {
    owner = "duplicity";
    repo = "duplicity";
    rev = "rel.${version}";
    hash = "sha256-4IwKqXlG7jh1siuPT5pVgiYB+KlmCzF6+OMPT3I3yTQ=";
  };

  patches = [
    ./keep-pythonpath-in-testing.patch
  ];

  postPatch = ''
    patchShebangs duplicity/__main__.py

    # don't try to use gtar on darwin/bsd
    substituteInPlace testing/functional/test_restart.py \
      --replace-fail 'tarcmd = "gtar"' 'tarcmd = "tar"'
  '' + lib.optionalString stdenv.isDarwin ''
    # tests try to access these files in the sandbox, but can't deal with EPERM
    substituteInPlace testing/unit/test_globmatch.py \
      --replace-fail /var/log /test/log
    substituteInPlace testing/unit/test_selection.py \
      --replace-fail /usr/bin /dev
    # don't use /tmp/ in tests
    substituteInPlace duplicity/backends/_testbackend.py \
      --replace-fail '"/tmp/' 'os.environ.get("TMPDIR")+"/'
  '';

  disabledTests = lib.optionals stdenv.isDarwin [
    # uses /tmp/
    "testing/unit/test_cli_main.py::CommandlineTest::test_intermixed_args"
  ];

  nativeBuildInputs = [
    makeWrapper
    gettext
    python3.pkgs.wrapPython
    wrapGAppsNoGuiHook
    python3.pkgs.setuptools-scm
  ];

  buildInputs = [
    librsync
    # For Gio typelib
    glib
  ];

  pythonPath = with python3.pkgs; [
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
  ] ++ lib.optionals stdenv.isDarwin [
    getconf
  ] ++ (with python3.pkgs; [
    lockfile
    mock
    pexpect
    pytest
    pytest-runner
    fasteners
  ]);

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  dontWrapGApps = true;

  preFixup = let
    binPath = lib.makeBinPath ([
      gnupg
      ncftp
      rsync
    ] ++ lib.optionals stdenv.isDarwin [
      getconf
    ]); in ''
    makeWrapperArgsBak=("''${makeWrapperArgs[@]}")
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : "${binPath}"
    )
  '';

  postFixup = ''
    # Restore previous value for tests wrapping in preInstallCheck
    makeWrapperArgs=("''${makeWrapperArgsBak[@]}")
  '';

  preCheck = ''
    # tests need writable $HOME
    HOME=$PWD/.home

    wrapPythonProgramsIn "$PWD/testing/overrides/bin" "$pythonPath"
  '';

  doCheck = true;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex" "rel\.(.*)" ];
    };

    tests.version = testers.testVersion {
      package = self;
    };
  };

  meta = with lib; {
    description = "Encrypted bandwidth-efficient backup using the rsync algorithm";
    homepage = "https://duplicity.gitlab.io/duplicity-web/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ corngood ];
  };
};

in self
