{ stdenv, buildPythonPackage, fetchFromGitHub, ua-parser }:

buildPythonPackage rec {
  pname = "user-agents";
  version = "1.1.0";

  # PyPI is missing devices.json
  src = fetchFromGitHub {
    owner = "selwin";
    repo = "python-user-agents";
    rev = "v${version}";
    sha256 = "14kxd780zhp8718xr1z63xffaj3bvxgr4pldh9sv943m4hvi0gw5";
  };

  propagatedBuildInputs = [ ua-parser ];

  doCheck = false; # some tests fail due to ua-parser bump to 0.8.0

  meta = with stdenv.lib; {
    description = "A Python library to identify devices by parsing user agent strings";
    homepage = https://github.com/selwin/python-user-agents;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
  };
}
