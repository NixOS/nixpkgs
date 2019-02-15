{ lib, buildPythonPackage, pythonAtLeast, isPy27, fetchPypi
, panflute, backports_csv }:

buildPythonPackage rec {
  pname = "pantable";
  version = "0.12.2";

  disabled = ! pythonAtLeast "3.5" && !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wk3fff87jf3srx0q370ggblng0vxx0lphxhy8m2wypw7ap3q8xw";
  };

  propagatedBuildInputs = [ panflute backports_csv ];

  meta = with lib; {
    description = "CSV Tables in Markdown: Pandoc Filter for CSV Tables";
    homepage = https://ickc.github.io/pantable/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ leenaars ];
  };
}
