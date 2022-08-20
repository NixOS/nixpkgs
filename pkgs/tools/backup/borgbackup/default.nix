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
}:

python3.pkgs.buildPythonApplication rec {
  pname = "borgbackup";
  version = "1.2.2";
  format = "pyproject";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-1zBodEPxvrYCsdcrrjYxj2+WVIGPzcUEWFQOxXnlcmA=";
  };

  postPatch = ''
    # sandbox does not support setuid/setgid/sticky bits
    substituteInPlace src/borg/testsuite/archiver.py \
      --replace "0o4755" "0o0755"
  '';

  nativeBuildInputs = with python3.pkgs; [
    cython
    setuptools-scm

    # docs
    sphinx
    guzzle_sphinx_theme

    # shell completions
    installShellFiles
  ];

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
    make -C docs singlehtml
    mkdir -p $out/share/doc/borg
    cp -R docs/_build/singlehtml $out/share/doc/borg/html

    make -C docs man
    mkdir -p $out/share/man
    cp -R docs/_build/man $out/share/man/man1

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

  outputs = [ "out" "doc" ];

  meta = with lib; {
    description = "Deduplicating archiver with compression and encryption";
    homepage = "https://www.borgbackup.org";
    license = licenses.bsd3;
    platforms = platforms.unix; # Darwin and FreeBSD mentioned on homepage
    mainProgram = "borg";
    maintainers = with maintainers; [ flokli dotlambda globin ];
  };
}
