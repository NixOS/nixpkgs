{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  stups-tokens,
  stups-cli-support,
  pytestCheckHook,
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
      sha256 = "1zmyvg1z1asaqqsmxvsx0srvxd6gkgavppvg3dblxwhkml01awqk";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    stups-tokens
    stups-cli-support
  ];

  preCheck = "
    export HOME=$TEMPDIR
  ";

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "OAuth2 token management command line utility";
    homepage = "https://github.com/zalando-stups/zign";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.mschuwalow ];
  };
}
