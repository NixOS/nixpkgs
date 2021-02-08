{ buildPythonPackage
, fetchFromGitHub
, jinja2
, pyyaml
, lib
}:

buildPythonPackage rec {
  pname = "swagger-ui-py";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "PWZER";
    repo = "swagger-ui-py";
    rev = "v${version}";
    sha256 = "1910zvkp2613s4ysb61k2gkaw3m1hdg2433kbqil80mqm915i1ix";
  };

  propagatedBuildInputs = [
    jinja2
    pyyaml
  ];

  meta = with lib; {
      description = "A web framework, such as Tornado, Flask, Quart, aiohttp, Sanic and Falcon";
      homepage = "https://github.com/PWZER/swagger-ui-py";
      license = licenses.mit;
      maintainers = with maintainers; [ majesticmullet ];
  };
}
