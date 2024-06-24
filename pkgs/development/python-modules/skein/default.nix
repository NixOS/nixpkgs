{
  buildPythonPackage,
  callPackage,
  fetchPypi,
  isPy27,
  pythonOlder,
  lib,
  cryptography,
  grpcio,
  pyyaml,
  grpcio-tools,
  hadoop,
  pytestCheckHook,
  python,
  setuptools,
  versioneer,
}:

buildPythonPackage rec {
  pname = "skein";
  version = "0.8.2";
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nXTqsJNX/LwAglPcPZkmdYPfF+vDLN+nNdZaDFTrHzE=";
  };

  # Update this hash if bumping versions
  jarHash = "sha256-x2KH6tnoG7sogtjrJvUaxy0PCEA8q/zneuI969oBOKo=";
  skeinJar = callPackage ./skeinjar.nix { inherit pname version jarHash; };

  propagatedBuildInputs = [
    cryptography
    grpcio
    pyyaml
  ] ++ lib.optionals (!pythonOlder "3.12") [ setuptools ];
  buildInputs = [ grpcio-tools ];

  preBuild = ''
    # Ensure skein.jar exists skips the maven build in setup.py
    mkdir -p skein/java
    ln -s ${skeinJar} skein/java/skein.jar
  '';

  postPatch =
    ''
      substituteInPlace skein/core.py --replace "'yarn'" "'${hadoop}/bin/yarn'" \
        --replace "else 'java'" "else '${hadoop.jdk}/bin/java'"
      # Remove vendorized versioneer
      rm versioneer.py
    ''
    + lib.optionalString (!pythonOlder "3.12") ''
      substituteInPlace skein/utils.py \
        --replace-fail "distutils" "setuptools._distutils"
    '';

  build-system = [ versioneer ];

  pythonImportsCheck = [ "skein" ];

  nativeCheckInputs = [ pytestCheckHook ];
  # These tests require connecting to a YARN cluster. They could be done through NixOS tests later.
  disabledTests = [
    "test_ui"
    "test_tornado"
    "test_kv"
    "test_core"
    "test_cli"
  ];

  meta = {
    homepage = "https://jcristharif.com/skein";
    description = "Tool and library for easily deploying applications on Apache YARN";
    mainProgram = "skein";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      alexbiehl
      illustris
    ];
    # https://github.com/NixOS/nixpkgs/issues/48663#issuecomment-1083031627
    # replace with https://github.com/NixOS/nixpkgs/pull/140325 once it is merged
    broken = lib.traceIf isPy27 "${pname} not supported on ${python.executable}" isPy27;
  };
}
