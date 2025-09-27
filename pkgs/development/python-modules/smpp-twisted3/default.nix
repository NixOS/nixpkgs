{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,
  writeScript,

  # Build system and deps
  setuptools,
  twisted,
  smpp-pdu,

  # Tests
  pytestCheckHook,
  mock,
  pyopenssl,
  service-identity,
}:

buildPythonPackage rec {
  pname = "smpp-twisted3";
  version = "0.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jookies";
    repo = "smpp.twisted";
    rev = "c9b266f54e44e7aff964b64cfb05ca1ecbcd7710"; # v0.8
    hash = "sha256-Uz5f4RCHE4+XTe0jBWVDfinWTHNvrf9jXvsM9ad00uk=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools ];

  dependencies = [
    twisted
    smpp-pdu
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyopenssl
    mock
    service-identity
  ];

  # Tests fail with sandbox
  doCheck = !(stdenv.hostPlatform.isDarwin);

  passthru.updateScript = writeScript "update-${pname}" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p yq git common-updater-scripts perl

    tmpdir="$(mktemp -d)"
    git clone --depth=1 "${src.gitRepoUrl}" "$tmpdir"

    pushd "$tmpdir"
    newVersion=$(yq -r '.version|ltrimstr("v")' nfpm.yaml | tr -d '\n')
    newRevision=$(git show -s --pretty='format:%H')
    popd

    rm -rf "$tmpdir"
    update-source-version --rev="$newRevision" "python3Packages.${pname}" "$newVersion"
    perl -pe 's/^(.*rev.*=.*# v)([\d\.]+)$/''${1}'"''${newVersion}"'/' \
      -i 'pkgs/development/python-modules/${pname}/default.nix'
  '';

  meta = {
    description = "SMPP 3.4 client built on Twisted";
    homepage = "https://pypi.org/project/smpp.twisted3";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
