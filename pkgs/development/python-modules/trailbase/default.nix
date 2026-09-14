{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pythonOlder,
  httpx,
  pyjwt,
  cryptography,
  pytestCheckHook,
  mintotp,
  trailbase,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "trailbase";
  version = "0.7.2";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-iWdxMgjEPd5RkCRY3JnzuaJ1nW6LOESciTB6j2lzPzM=";
  };

  # Tests are not on PyPI.
  prePatch = ''
    cp -r ${trailbase.src}/client/python/tests tests
    chmod -R u+w tests
  '';

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
    cp -r ${trailbase.src}/client/testfixture "$TRAILBASE_TESTFIXTURE"
    chmod -R u+w "$TRAILBASE_TESTFIXTURE"

    # promote_anonymous tries to send mail; the fixture has no SMTP.
    mkdir -p "$TMPDIR/bin"
    printf '%s\n' '#!/bin/sh' 'cat >/dev/null' > "$TMPDIR/bin/sendmail"
    chmod +x "$TMPDIR/bin/sendmail"
    export PATH="$TMPDIR/bin:$PATH"
  '';

  pythonImportsCheck = [ "trailbase" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TrailBase client for Python";
    homepage = "https://pypi.org/project/trailbase/";
    changelog = "https://github.com/trailbaseio/trailbase/releases";
    license = with lib.licenses; [
      asl20
      osl3
    ];
    maintainers = [ lib.maintainers.lucasew ];
    teams = [ lib.teams.ngi ];
  };
})
