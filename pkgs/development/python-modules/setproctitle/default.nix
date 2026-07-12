{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  pytestCheckHook,
  procps,
  stdenv,
}:

buildPythonPackage rec {
  pname = "setproctitle";
  version = "1.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dvarrazzo";
    repo = "py-setproctitle";
    tag = "version-${version}";
    hash = "sha256-dfOdtfOXRAoCQLW307+YMsFIWRv4CupbKUxckev1oUw=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/dvarrazzo/py-setproctitle/commit/68125abf821ee6ebfb4a4eb86ffe655a4c072c9e.patch";
      hash = "sha256-ZeY/4z7EFY9Tc4Y4T3BCyEt2Gweqts/8qwqdWT1e6BM=";
    })
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    procps
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # Setting the process title fails on macOS in the Nix builder environment (regardless of sandboxing)
    "test_setproctitle_darwin"
    # *** multi-threaded process forked ***; crashed on child side of fork pre-exec. fork without exec is unsafe.
    "test_fork_segfault"
    "test_thread_fork_segfault"
  ];

  pythonImportsCheck = [ "setproctitle" ];

  meta = {
    description = "Allows a process to change its title (as displayed by system tools such as ps and top)";
    homepage = "https://github.com/dvarrazzo/py-setproctitle";
    changelog = "https://github.com/dvarrazzo/py-setproctitle/blob/${src.tag}/HISTORY.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ exi ];
  };
}
