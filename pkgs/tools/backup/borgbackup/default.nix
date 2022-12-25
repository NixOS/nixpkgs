{ lib
, stdenv
, acl
, e2fsprogs
, libb2
, lz4
, openssh
, openssl
, python3
, zstd
, installShellFiles
, nixosTests
, fetchpatch
}:

python3.pkgs.buildPythonApplication rec {
  pname = "borgbackup";
  version = "1.2.3";
  format = "pyproject";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-4yQY+GM8lvqWgTUqVutjuY4pQgNHLBFKUkJwnTaWZ4U=";
  };

  patches = [
    (fetchpatch {
      # Fix HashIndexSizeTestCase.test_size_on_disk_accurate problems on ZFS,
      # see https://github.com/borgbackup/borg/issues/7250
      url = "https://github.com/borgbackup/borg/pull/7252/commits/537a814e53e20013a041faa7192da005f137cf5b.patch";
      hash = "sha256-dnF/FW8pS4Ub9aAL4b7zf6ZNjMZaiMqdtl5R+DlAZTM=";
    })
  ];

  postPatch = ''
    # sandbox does not support setuid/setgid/sticky bits
    substituteInPlace src/borg/testsuite/archiver.py \
      --replace "0o4755" "0o0755"
  '';

  nativeBuildInputs = with python3.pkgs; [
    cython
    setuptools-scm

    # docs
    sphinxHook
    guzzle_sphinx_theme

    # shell completions
    installShellFiles
  ];

  sphinxBuilders = [ "singlehtml" "man" ];

  buildInputs = [
    libb2
    lz4
    zstd
    openssl
  ] ++ lib.optionals stdenv.isLinux [
    acl
  ];

  propagatedBuildInputs = with python3.pkgs; [
    msgpack
    packaging
    (if stdenv.isLinux then pyfuse3 else llfuse)
  ];

  preConfigure = ''
    export BORG_OPENSSL_PREFIX="${openssl.dev}"
    export BORG_LZ4_PREFIX="${lz4.dev}"
    export BORG_LIBB2_PREFIX="${libb2}"
    export BORG_LIBZSTD_PREFIX="${zstd.dev}"
  '';

  makeWrapperArgs = [
    ''--prefix PATH ':' "${openssh}/bin"''
  ];

  postInstall = ''
    installShellCompletion --cmd borg \
      --bash scripts/shell_completions/bash/borg \
      --fish scripts/shell_completions/fish/borg.fish \
      --zsh scripts/shell_completions/zsh/_borg
  '';

  checkInputs = with python3.pkgs; [
    e2fsprogs
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
    description = "Deduplicating archiver with compression and encryption";
    homepage = "https://www.borgbackup.org";
    license = licenses.bsd3;
    platforms = platforms.unix; # Darwin and FreeBSD mentioned on homepage
    mainProgram = "borg";
    maintainers = with maintainers; [ dotlambda globin ];
  };
}
