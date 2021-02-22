{ lib, buildPythonPackage, fetchurl, jieba, pkuseg, spacy }:
let
  buildModelPackage = { pname, version, sha256, license }:
  let
    lang = builtins.substring 0 2 pname;
  in buildPythonPackage {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/explosion/spacy-models/releases/download/${pname}-${version}/${pname}-${version}.tar.gz";
      inherit sha256;
    };

    propagatedBuildInputs = [ spacy ]
      ++ lib.optionals (lang == "zh") [ jieba pkuseg ];

    pythonImportsCheck = [ pname ];

    meta = with lib; {
      description = "Models for the spaCy NLP library";
      homepage    = "https://github.com/explosion/spacy-models";
      license     = licenses.${license};
      maintainers = with maintainers; [ rvl ];
    };
  };

  makeModelSet = models: with lib; listToAttrs (map (m: nameValuePair m.pname (buildModelPackage m)) models);

in makeModelSet (lib.importJSON ./models.json)

# cat models.json | jq -r '.[] | @uri "https://github.com/explosion/spacy-models/releases/download/\(.pname)-\(.version)/\(.pname)-\(.version).tar.gz"' | xargs -n1 nix-prefetch-url
