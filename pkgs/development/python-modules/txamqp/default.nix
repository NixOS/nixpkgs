{
  lib,
  buildPythonPackage,
  fetchPypi,
  twisted,
}:

buildPythonPackage rec {
  pname = "txamqp";
  version = "0.8.2";

  src = fetchPypi {
    pname = "txAMQP";
    inherit version;
    hash = "sha256-ZEeixSlIdutYwGX+iTQpgOCaJpWfxxunAUyzMYlBqUk=";
  };

  propagatedBuildInputs = [ twisted ];

  meta = with lib; {
    homepage = "https://github.com/txamqp/txamqp";
    description = "Library for communicating with AMQP peers and brokers using Twisted";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
