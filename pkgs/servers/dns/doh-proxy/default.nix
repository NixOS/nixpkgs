{ lib, python3Packages }:

with python3Packages;
buildPythonApplication rec {
  pname = "doh-proxy";
  version = "0.0.9";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1fxzxipzdvk75yrcr78mpdz8lwpisba67lk4jcwxdnkv6997dwfp";
  };

  nativeBuildInputs = [ pytestrunner flake8];

  propagatedBuildInputs = [
    aioh2
    dnspython
    aiohttp-remotes
  ];

  checkInputs = [
    asynctest
    unittest-data-provider
    pytest
    pytestcov
    pytest-aiohttp
  ];

  # attempts to resolve address
  checkPhase = ''
    pytest -k 'not servers'
  '';

  meta = with lib; {
    homepage = https://facebookexperimental.github.io/doh-proxy/;
    description = "A proof of concept DNS-Over-HTTPS proxy";
    license = licenses.bsd3;
    maintainers = [ maintainers.qyliss ];
  };
}
