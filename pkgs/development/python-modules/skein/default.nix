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
  version = "0.8.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "04208b4be9df2dc68ac5b3e3ae51fd9b589add95ea1b67222a8de754d17b1efa";
  };
  # Update this hash if bumping versions
  jarHash = "sha256-UGiEoTZ17IhLG72FZ18Zb+Ej4T8z9rMIMDUxzSZGZyY=";
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

  checkInputs = [ pytestCheckHook ];
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
