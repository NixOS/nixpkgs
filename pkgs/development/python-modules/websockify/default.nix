{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  jwcrypto,
  numpy,
  pytestCheckHook,
  redis,
  requests,
  simplejson,
}:

buildPythonPackage (finalAttrs: {
  pname = "websockify";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "novnc";
    repo = "websockify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b57L4o071zEt/gX9ZVzEpcnp0RCeo3peZrby2mccJgQ=";
  };

  patches = [
    # https://github.com/novnc/websockify/pull/638
    (fetchpatch {
      name = "replace-test-symmetric-key.patch";
      url = "https://github.com/novnc/websockify/commit/f1e281d2c446380a0a8af7575a92b23ad65c6d4d.patch";
      hash = "sha256-l+j+baTDSEXhOajUKxaT21ET1iEnpiBHwysYnTt3ghk=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    jwcrypto
    numpy
    redis
    requests
    simplejson
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  __darwinAllowLocalNetworking = true;

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # this test failed on macos
    # https://github.com/novnc/websockify/issues/552
    "test_socket_set_keepalive_options"
  ];

  pythonImportsCheck = [ "websockify" ];

  meta = {
    description = "WebSockets support for any application/server";
    mainProgram = "websockify";
    homepage = "https://github.com/novnc/websockify";
    changelog = "https://github.com/novnc/websockify/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Only;
    maintainers = [ ];
  };
})
