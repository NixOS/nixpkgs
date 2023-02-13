{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, suds-jurko
, python-ldap
, mechanize
, beautifulsoup4
, pyxdg
, python-dateutil
, requests
, httpretty
}:

buildPythonPackage rec {
  pname = "suseapi";
  version = "0.24-31-g0fcbe96";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "python-${pname}";
    rev = version;
    sha256 = "0hyzq0h1w8gp0zfvhqh7qsgcg1wp05a14371m6bn5a7gss93rbv4";
  };

  propagatedBuildInputs = [
    django suds-jurko python-ldap mechanize beautifulsoup4 pyxdg python-dateutil requests
  ];

  buildInputs = [ httpretty ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/openSUSE/python-suseapi/";
    description = "Python module to work with various SUSE services";
    license = lib.licenses.gpl3Plus;
  };
}
