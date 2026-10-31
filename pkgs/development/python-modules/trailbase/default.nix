{
  lib,
  stdenv,
  buildPythonPackage,
  poetry-core,
  httpx,
  pyjwt,
  cryptography,
  pytestCheckHook,
  mintotp,
  trailbase,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "trailbase";
  version = "0.7.4";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = trailbase.src;
  sourceRoot = "${finalAttrs.src.name}/client/python";

  patches = [ ./use-packaged-server.patch ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Python builds for different version (e.g. 3.13 and 3.14) run concurrently
    # on Darwin with no network isolation, so they'd both bind the hardcoded
    # test port 4007, which can lead to issues.
    #
    # To fix this, we offset the test port by the Python minor version so they
    # don't conflict and mess with each other.
    substituteInPlace tests/test_client.py \
      --replace-fail \
        'port = 4007' \
        'port = 4007 + __import__("sys").version_info.minor'
  '';

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "httpx"
    "cryptography"
  ];

  dependencies = [
    cryptography
    httpx
    pyjwt
  ];

  nativeCheckInputs = [
    mintotp
    pytestCheckHook
    trailbase
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    export TRAILBASE_BIN=${lib.getExe trailbase}
    export TRAILBASE_TESTFIXTURE="$TMPDIR/testfixture"
    cp -r ${finalAttrs.src}/client/testfixture "$TRAILBASE_TESTFIXTURE"
    chmod -R u+w "$TRAILBASE_TESTFIXTURE"

    # promote_anonymous tries to send mail; the fixture has no SMTP.
    mkdir -p "$TMPDIR/bin"
    printf '%s\n' '#!/bin/sh' 'cat >/dev/null' > "$TMPDIR/bin/sendmail"
    chmod +x "$TMPDIR/bin/sendmail"
    export PATH="$TMPDIR/bin:$PATH"
  '';

  pythonImportsCheck = [ "trailbase" ];

  # nixpkgs-update: no auto update
  #  (automatically sycned with trailbase package)

  meta = {
    description = "TrailBase client for Python";

    inherit (trailbase.meta)
      homepage
      changelog
      maintainers
      teams
      ;

    license =
      with lib.licenses;
      OR [
        asl20
        osl3
      ];
  };
})
