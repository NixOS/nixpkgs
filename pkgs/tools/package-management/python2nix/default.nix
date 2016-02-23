{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "python2nix-20140927";
 
  src = fetchFromGitHub {
    owner = "proger";
    repo = "python2nix";
    rev = "84e3a5bbe82e5d9d694d6db8dabf73def4ac917b";
    sha256 = "022gr0gw6azfi3iq4ggb3fhkw2jljs6n5rncn45hb5liwakigj8i";
  };

  propagatedBuildInputs = with pythonPackages; [ requests pip setuptools ];

  meta = with stdenv.lib; {
    maintainers = [ maintainers.iElectric ];
    platforms = platforms.all;
  };
}
