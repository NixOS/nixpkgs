{ lib
, stdenv
, acl
, e2fsprogs
, fetchFromGitHub
, libb2
, lz4
, openssh
, openssl
, python3
, xxHash
, zstd
, installShellFiles
, nixosTests
}:

let
  python = python3;
in
python.pkgs.buildPythonApplication rec {
  pname = "borgbackup";
  version = "1.2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "borgbackup";
    repo = "borg";
    rev = "refs/tags/${version}";
    hash = "sha256-+FHqOVuHlY9QUjCrYVnrMBZPMFH9Z2U7eZ6eUSINSrw=";
  };

  postPatch = ''
    # sandbox does not support setuid/setgid/sticky bits
    substituteInPlace src/borg/testsuite/archiver.py \
      --replace-fail "0o4755" "0o0755"
  '';

  build-system = with python.pkgs; [
    cython
    setuptools-scm
    pkgconfig
  ];

  nativeBuildInputs = with python.pkgs; [
    # docs
    sphinxHook
    guzzle-sphinx-theme

    # shell completions
    installShellFiles
  ];

  sphinxBuilders = [ "singlehtml" "man" ];

  buildInputs = [
    libb2
    lz4
    xxHash
    zstd
    openssl
  ] ++ lib.optionals stdenv.isLinux [
    acl
  ];

  dependencies = with python.pkgs; [
    msgpack
    packaging
    (if stdenv.isLinux then pyfuse3 else llfuse)
  ];

  makeWrapperArgs = [
    ''--prefix PATH ':' "${openssh}/bin"''
  ];

  postInstall = ''
    installShellCompletion --cmd borg \
      --bash scripts/shell_completions/bash/borg \
      --fish scripts/shell_completions/fish/borg.fish \
      --zsh scripts/shell_completions/zsh/_borg
  '';

  nativeCheckInputs = with python.pkgs; [
    e2fsprogs
    py
    python-dateutil
    pytest-benchmark
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--benchmark-skip"
    "--pyargs" "borg.testsuite"
  ];

  disabledTests = [
    # fuse: device not found, try 'modprobe fuse' first
    "test_fuse"
    "test_fuse_allow_damaged_files"
    "test_fuse_mount_hardlinks"
    "test_fuse_mount_options"
    "test_fuse_versions_view"
    "test_migrate_lock_alive"
    "test_readonly_mount"
    # Error: Permission denied while trying to write to /var/{,tmp}
    "test_get_cache_dir"
    "test_get_keys_dir"
    "test_get_security_dir"
    "test_get_config_dir"
    # https://github.com/borgbackup/borg/issues/6573
    "test_basic_functionality"
  ];

  preCheck = ''
    export HOME=$TEMP
  '';

  passthru.tests = {
    inherit (nixosTests) borgbackup;
  };

  outputs = [ "out" "doc" "man" ];

  meta = with lib; {
    changelog = "https://github.com/borgbackup/borg/blob/${src.rev}/docs/changes.rst";
    description = "Deduplicating archiver with compression and encryption";
    homepage = "https://www.borgbackup.org";
    license = licenses.bsd3;
    platforms = platforms.unix; # Darwin and FreeBSD mentioned on homepage
    mainProgram = "borg";
    maintainers = with maintainers; [ dotlambda globin ];
  };
}
