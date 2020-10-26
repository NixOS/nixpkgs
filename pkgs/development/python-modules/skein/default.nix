{ buildPythonPackage
, callPackage
, fetchPypi
, isPy27
, jre
, lib
, pythonPackages
, stdenv
}:

let
  pname = "skein";
  version = "0.8.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "0nb64p1hzshgi1kfc2jx1v9vn8b0wzs50460wfra3fsxh0ap66ab";
  };
  skeinJar = callPackage ./skeinjar.nix { inherit src version; };
in
buildPythonPackage rec {
  inherit pname version src;
  disabled = isPy27;

  propagatedBuildInputs = with pythonPackages; [ cryptography grpcio grpcio-tools jupyter pytest pyyaml requests jre ];

  preBuild = ''
    # Ensure skein.jar exists skips the maven build in setup.py
    mkdir -p skein/java
    ln -s ${skeinJar} skein/java/skein.jar
  '';

  meta = with stdenv.lib; {
    broken = true;
    homepage = "https://jcristharif.com/skein";
    description = "A tool and library for easily deploying applications on Apache YARN";
    license = licenses.bsd3;
    maintainers = with maintainers; [ alexbiehl ];
  };

}
