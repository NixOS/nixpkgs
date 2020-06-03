{ python, stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "0.1.0";
  pname = "typechecks";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d801a6018f60d2a10aa3debc3af65f590c96c455de67159f39b9b183107c83b";
  };

  pythonImportsCheck = [ "typechecks" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/openvax/typechecks";
    description = "Helper functions for runtime type checking";
    license = licenses.asl20;
    maintainers = [ maintainers.moritzs ];
  };
}
