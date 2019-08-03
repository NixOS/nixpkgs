{ stdenv, buildPythonPackage, fetchFromGitHub, ua-parser }:

buildPythonPackage rec {
  pname = "user-agents";
  version = "2.0";

  # PyPI is missing devices.json
  src = fetchFromGitHub {
    owner = "selwin";
    repo = "python-user-agents";
    rev = "v${version}";
    sha256 = "0ix2yajqdnfj433j50dls90mkmqz8m4fiywxg097zwkkc95wm8s4";
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
