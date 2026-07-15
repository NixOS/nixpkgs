{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  paramiko,
  pytestCheckHook,
  setuptools,
  tornado,
}:

buildPythonPackage rec {
  pname = "webssh";
  version = "1.6.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-K85buvIGrTRZEMfk3IAks8QY5oHJ9f8JjxgCvv924QA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    paramiko
    tornado
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "webssh" ];

  disabledTests = [
    # https://github.com/huashengdun/webssh/issues/412
    "test_get_pkey_obj_with_encrypted_ed25519_key"
    "test_get_pkey_obj_with_encrypted_new_rsa_key"
    "test_get_pkey_obj_with_plain_new_dsa_key"
    # BrokenPipeError: [Errno 32] Broken pipe
    "test_app_post_form_with_large_body_size_by_multipart_form"
    "test_app_post_form_with_large_body_size_by_urlencoded_form"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Web based SSH client";
    mainProgram = "wssh";
    homepage = "https://github.com/huashengdun/webssh/";
    changelog = "https://github.com/huashengdun/webssh/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
