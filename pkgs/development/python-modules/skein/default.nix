{ buildPythonPackage
, callPackage
, fetchPypi
, isPy27
, lib
, cryptography
, grpcio
, pyyaml
, grpcio-tools
, hadoop
, pytestCheckHook
, python
}:

buildPythonPackage rec {
  pname = "skein";
  version = "0.8.2";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nXTqsJNX/LwAglPcPZkmdYPfF+vDLN+nNdZaDFTrHzE=";
  };

  # Update this hash if bumping versions
  jarHash = "sha256-x2KH6tnoG7sogtjrJvUaxy0PCEA8q/zneuI969oBOKo=";
  skeinJar = callPackage ./skeinjar.nix { inherit pname version jarHash; };

  propagatedBuildInputs = [ cryptography grpcio pyyaml ];
  buildInputs = [ grpcio-tools ];

  preBuild = ''
    # Ensure skein.jar exists skips the maven build in setup.py
    mkdir -p skein/java
    ln -s ${skeinJar} skein/java/skein.jar
  '';

  postPatch = ''
    substituteInPlace skein/core.py --replace "'yarn'" "'${hadoop}/bin/yarn'" \
      --replace "else 'java'" "else '${hadoop.jdk}/bin/java'"
  '';

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

  meta = with lib; {
    homepage = "https://jcristharif.com/skein";
    description = "A tool and library for easily deploying applications on Apache YARN";
    license = licenses.bsd3;
    maintainers = with maintainers; [ alexbiehl illustris ];
    # https://github.com/NixOS/nixpkgs/issues/48663#issuecomment-1083031627
    # replace with https://github.com/NixOS/nixpkgs/pull/140325 once it is merged
    broken = lib.traceIf isPy27 "${pname} not supported on ${python.executable}" isPy27;
  };
}
