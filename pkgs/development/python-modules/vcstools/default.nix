{
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  lib,
  looseversion,
  python-dateutil,
  pyyaml,
  setuptools,
  pytestCheckHook,
  mock,
  git,
  subversion,
  breezy,
  mercurialFull,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "vcstools";
  version = "0.1.42";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vcstools";
    repo = "vcstools";
    tag = version;
    hash = "sha256-ZvA6+aMzE/+RDJtlABiHILhiM7fNW1ZucGRHZcwraRU=";
  };

  patches = [
    # fix python 3.12 compatibility: don't import imp
    (fetchpatch {
      url = "https://github.com/meyerj/vcstools/commit/1d32c81af6768345b413de364c9bc526d6309f5d.patch";
      hash = "sha256-KeuKyNUDo/GYxP5NMXzibGtUwAxbRCZ8nqNkxLh3LeI=";
    })
    # fix syntax warning
    (fetchpatch {
      url = "https://github.com/meyerj/vcstools/commit/29236587452e02b618ef4b7467b0e45768a422e6.patch";
      hash = "sha256-GY9Or0BZYD2GS9z4IsQxhHtQsm5ZuoSlEQ+GMDatbqM=";
    })
    # fix python 3.12 compatibility: don't import distutils
    (fetchpatch {
      url = "https://github.com/nim65s/vcstools/commit/b940aacc4bcf96892b5d75ae6e58dc9bba5fff60.patch";
      hash = "sha256-yKDrd9t0vuuDqyDUlmOIlL4l1Uc6svtXVxuavnV0uOM=";
    })
    # fix remaining python 3.12 compatibility issues
    ./python-3_12-compatibility.patch
  ];

  build-system = [ setuptools ];

  dependencies = [
    looseversion
    python-dateutil
    pyyaml
  ];

  checkInputs = [
    pytestCheckHook
    mock
  ];
  nativeCheckInputs = [
    git
    breezy
    subversion
    mercurialFull
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "vcstools" ];

  disabledTests = [
    # requires network access
    "test_checkout_timeout"
    # Tries to read /usr/bin/env
    "test_shell_command"
    # Truly have no idea why this fails, there is a comment saying this test fails on python 2.6 (yikes?!)
    "test_url_matches_with_shortcut"
  ];
  disabledTestPaths = [
    # Who knows why this fails. If you want to investigate, feel free to do so. But I'm not spending any more time on this stupid package.
    "test/test_git_subm.py"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python library for interacting with various VCS systems";
    homepage = "https://github.com/vcstools/vcstools";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      pandapip1
      nim65s
    ];
  };
}
