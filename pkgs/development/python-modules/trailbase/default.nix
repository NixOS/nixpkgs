{
  lib,
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

  src = trailbase.src;
  sourceRoot = "${finalAttrs.src.name}/client/python";

  patches = [ ./use-packaged-server.patch ];

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
