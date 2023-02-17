{ lib
, stdenv
, python
, buildPythonPackage
, pythonOlder
, fetchPypi
, cryptography
, incremental
, twisted
, automat
, zope_interface
, idna
, pyopenssl
, service-identity
, pytestCheckHook
, mock
, lsof
, GeoIP
}:

buildPythonPackage rec {
  pname = "txtorcon";
  version = "23.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AiX/rWdokTeEmtmtNK21abDYj5rwRQMABnpfkB6ZQyU=";
  };

  propagatedBuildInputs = [
    cryptography
    incremental
    twisted
    automat
    zope_interface
  ] ++ twisted.optional-dependencies.tls;

  nativeCheckInputs = [ pytestCheckHook mock lsof GeoIP ];

  doCheck = !(stdenv.isDarwin && stdenv.isAarch64);

  meta = {
    description = "Twisted-based Tor controller client, with state-tracking and configuration abstractions";
    homepage = "https://github.com/meejah/txtorcon";
    maintainers = with lib.maintainers; [ jluttine exarkun ];
    license = lib.licenses.mit;
  };
}
