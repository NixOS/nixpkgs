{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "gay";
  version = "1.2.8";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-/4IHqAoJthKvNyKqUgnGOQkgbC0aBEZ+x6dmKWUHXh0=";
  };

  meta = with lib; {
    description = "Colour your text / terminal to be more gay";
    longDescription = ''
      Applies pride flag colors to text, ala lolcat or displays a pride flag.
    '';
    homepage = "https://github.com/ms-jpq/gay";
    maintainers = with maintainers; [ CodeLongAndProsper90 ];
    license = licenses.mit;
  };
}
