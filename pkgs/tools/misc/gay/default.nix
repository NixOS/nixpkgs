{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "gay";
  version = "1.2.8";

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = "gay";
    # The repo doesn't have any tags
    # This references version 1.2.8
    rev = "1e3e96815c68214533a925c86a52b0acf832a359";
    sha256 = "sha256-vouEFybcz27bcw/CpAGjFY8NYWQC+V0IE7h1a8XufZ0=";
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
