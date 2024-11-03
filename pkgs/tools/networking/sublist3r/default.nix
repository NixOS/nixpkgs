{ lib, stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "sublist3r";
  version = "1.1.0";  # Replace with the latest version or tag if necessary

  src = fetchFromGitHub {
    owner = "aboul3la";
    repo = "Sublist3r";
    rev = "master";  # You can also use a specific commit or tag here
    sha256 = "0iz94bqsx6v4jj68h4673hq5z1ymlbcjrm8ybnb0w7q863gdpfcy";  # Updated with actual hash
  };

  propagatedBuildInputs = with python3Packages; [ requests dnspython ];

  meta = with lib; {
    description = "Fast subdomains enumeration tool for penetration testers";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.PNP-MA];  # Replace with your GitHub username
    platforms = platforms.all;
  };
}

