{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  stups-tokens,
  stups-cli-support,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "stups-zign";
  version = "1.2";
  pyproject = true;
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "zalando-stups";
    repo = "zign";
    rev = version;
    hash = "sha256-BDqBNq2KHig86WCcDIxwKUE+jw1MMGhSd7Q0m6+9Zu4=";
  };

  patches = [
    # pytest 5 is currently unsupported. Fetch and apply a pr that resolves this.
    (fetchpatch {
      url = "https://github.com/zalando-stups/zign/commit/50140720211e547b0e59f7ddb39a732f0cc73ad7.patch";
      hash = "sha256-E3MVAK0T8k5XG2/fu9Wbz7S+swZd7141xkqr8MPbvv4=";
    })
  ];

  postPatch = ''
    substituteInPlace zign/__init__.py \
      --replace-fail "__version__ = '2016.0.dev1'" "__version__ = '${version}'"
  '';

  build-system = [ setuptools ];

  dependencies = [
    stups-tokens
    stups-cli-support
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "OAuth2 token management command line utility";
    homepage = "https://github.com/zalando-stups/zign";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.mschuwalow ];
  };
}
