{ buildPythonPackage
, callPackage
, fetchPypi
, isPy27
, jre
, lib
, pythonPackages

}:

let
  pname = "skein";
  version = "0.8.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "04208b4be9df2dc68ac5b3e3ae51fd9b589add95ea1b67222a8de754d17b1efa";
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

  meta = with lib; {
    homepage = "https://jcristharif.com/skein";
    description = "A tool and library for easily deploying applications on Apache YARN";
    license = licenses.bsd3;
    maintainers = with maintainers; [ alexbiehl ];
    broken = true; # maven repo src isn't stable
  };

}
