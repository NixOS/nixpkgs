{ lib
, stdenv
, acl
, e2fsprogs
, libb2
, lz4
, openssh
, openssl
<<<<<<< HEAD
, python3Packages
=======
, python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, xxHash
, zstd
, installShellFiles
, nixosTests
<<<<<<< HEAD
, fetchPypi
}:

python3Packages.buildPythonApplication rec {
  pname = "borgbackup";
  version = "1.2.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-t6b48IYDnu7HkHC5FPPGUe1/NhLJZTdK+RDSd8eiE50=";
  };

=======
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
      url = "https://github.com/borgbackup/borg/pull/7252/commits/fe3775cf8078c18d8fe39a7f42e52e96d3ecd054.patch";
      hash = "sha256-gdssHfhdkmRfSAOeXsq9Afg7xqGM3NLIq4QnzmPBhw4=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postPatch = ''
    # sandbox does not support setuid/setgid/sticky bits
    substituteInPlace src/borg/testsuite/archiver.py \
      --replace "0o4755" "0o0755"
  '';

<<<<<<< HEAD
  nativeBuildInputs = with python3Packages; [
=======
  nativeBuildInputs = with python3.pkgs; [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    cython
    setuptools-scm
    pkgconfig

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
    xxHash
    zstd
    openssl
  ] ++ lib.optionals stdenv.isLinux [
    acl
  ];

<<<<<<< HEAD
  propagatedBuildInputs = with python3Packages; [
=======
  propagatedBuildInputs = with python3.pkgs; [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  nativeCheckInputs = with python3Packages; [
=======
  nativeCheckInputs = with python3.pkgs; [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/borgbackup/borg/blob/${version}/docs/changes.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Deduplicating archiver with compression and encryption";
    homepage = "https://www.borgbackup.org";
    license = licenses.bsd3;
    platforms = platforms.unix; # Darwin and FreeBSD mentioned on homepage
    mainProgram = "borg";
    maintainers = with maintainers; [ dotlambda globin ];
  };
}
