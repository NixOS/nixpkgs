{ lib
, buildPythonPackage
, fetchurl
, jieba
, pymorphy2
, sentencepiece
, spacy
, spacy-pkuseg
, spacy-transformers }:
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
      ++ lib.optionals (lang == "zh") [ jieba spacy-pkuseg ]
      ++ lib.optionals (lib.hasSuffix "_trf" pname) [ spacy-transformers ]
      ++ lib.optionals (lang == "ru") [ pymorphy2 ]
      ++ lib.optionals (pname == "fr_dep_news_trf") [ sentencepiece ];

    postPatch = lib.optionalString (pname == "fr_dep_news_trf") ''
      substituteInPlace meta.json \
        --replace "sentencepiece==0.1.91" "sentencepiece>=0.1.91"
    '';

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
