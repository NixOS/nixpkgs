{ stdenv, buildPythonPackage, fetchFromGitHub, ua-parser }:

buildPythonPackage rec {
  pname = "user-agents";
  version = "2.1.0";

  # PyPI is missing devices.json
  src = fetchFromGitHub {
    owner = "selwin";
    repo = "python-user-agents";
    rev = "v${version}";
    sha256 = "04bndajsfnpymxfiggnj7g38cmlvca3ry5k2611x8ibp38x53yhc";
  };

  propagatedBuildInputs = [ ua-parser ];

  meta = with stdenv.lib; {
    description = "A Python library to identify devices by parsing user agent strings";
    homepage = https://github.com/selwin/python-user-agents;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
  };
}
