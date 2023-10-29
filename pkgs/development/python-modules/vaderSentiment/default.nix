{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "vaderSentiment";
  version = "3.3.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XXwG4Cf8i5kjjtsNU9lwz5cGbvl2VACYkLg3A4SWMvk=";
  };

  propagatedBuildInputs = [ requests ];

  pythonImportsCheck = [ "vaderSentiment" ];

  meta = {
    homepage = "https://github.com/cjhutto/vaderSentiment";
    description = "A lexicon and rule-based sentiment analysis tool";
    longDescription = ''
      VADER (Valence Aware Dictionary and sEntiment Reasoner) is a lexicon and
      rule-based sentiment analysis tool that is specifically attuned to sentiments
      expressed in social media, and works well on texts from other domains
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
