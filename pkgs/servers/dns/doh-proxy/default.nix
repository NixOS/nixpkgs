{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "doh-proxy";
  version = "0.0.8";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0mfl84mcklby6cnsw29kpcxj7mh1cx5yw6mjs4sidr1psyni7x6c";
  };

  propagatedBuildInputs = with python3Packages;
    [ aioh2 dnspython aiohttp-remotes pytestrunner flake8 ];
  doCheck = false; # Trouble packaging unittest-data-provider

  meta = with lib; {
    homepage = https://facebookexperimental.github.io/doh-proxy/;
    description = "A proof of concept DNS-Over-HTTPS proxy";
    license = licenses.bsd3;
    maintainers = [ maintainers.qyliss ];
  };
}
