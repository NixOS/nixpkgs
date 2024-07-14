{
  lib,
  buildPythonPackage,
  fetchPypi,
  termcolor,
  colorama,
}:

buildPythonPackage rec {
  pname = "veryprettytable";
  version = "0.8.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bkym/Iisrl3hPzf/fYsTCwPJ+ttJR9Eriwybjr6LOcw=";
  };

  propagatedBuildInputs = [
    termcolor
    colorama
  ];

  meta = with lib; {
    description = "Simple Python library for easily displaying tabular data in a visually appealing ASCII table format";
    homepage = "https://github.com/smeggingsmegger/VeryPrettyTable";
    license = licenses.free;
  };
}
