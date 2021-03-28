{ lib
, buildPythonApplication
, fetchPypi
, commandparse
, dnspython
, ldap3
, termcolor
, tqdm
}:

buildPythonApplication rec {
  pname = "ldeep";
  version = "1.0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/7mcmAj69NmuiK+xlQijAk39sMLDX8kHatmSI6XYbwE=";
  };

  propagatedBuildInputs = [
    commandparse
    dnspython
    ldap3
    termcolor
    tqdm
  ];

  # no tests are present
  doCheck = false;
  pythonImportsCheck = [ "ldeep" ];

  meta = with lib; {
    description = "In-depth LDAP enumeration utility";
    homepage = "https://github.com/franc-pentest/ldeep";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
