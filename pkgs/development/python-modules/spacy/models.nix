{
  lib,
  buildPythonPackage,
  fetchurl,
  protobuf,
  pymorphy3,
  pymorphy3-dicts-uk,
  sentencepiece,
  setuptools,
  spacy,
  spacy-pkuseg,
  spacy-curated-transformers,
  sudachipy,
  sudachidict-core,
  transformers,
  writeScript,
  stdenv,
  jq,
  nix,
  moreutils,
}:
let
  buildModelPackage =
    {
      pname,
      version,
      sha256,
      license,
    }:

    let
      lang = builtins.substring 0 2 pname;
      requires-protobuf =
        pname == "fr_dep_news_trf" || pname == "sl_core_news_trf" || pname == "uk_core_news_trf";
      requires-sentencepiece = pname == "fr_dep_news_trf" || pname == "sl_core_news_trf";
      requires-transformers = pname == "uk_core_news_trf";
    in
    buildPythonPackage {
      inherit pname version;
      pyproject = true;

      src = fetchurl {
        url = "https://github.com/explosion/spacy-models/releases/download/${pname}-${version}/${pname}-${version}.tar.gz";
        inherit sha256;
      };

      propagatedBuildInputs = [
        spacy
      ]
      ++ lib.optionals (lib.hasSuffix "_trf" pname) [ spacy-curated-transformers ]
      ++ lib.optionals requires-transformers [ transformers ]
      ++ lib.optionals (lang == "ja") [
        sudachidict-core
        sudachipy
      ]
      ++ lib.optionals (lang == "ru") [ pymorphy3 ]
      ++ lib.optionals (lang == "uk") [
        pymorphy3
        pymorphy3-dicts-uk
      ]
      ++ lib.optionals (lang == "zh") [ spacy-pkuseg ]
      ++ lib.optionals requires-sentencepiece [ sentencepiece ];

      postPatch =
        lib.optionalString requires-protobuf ''
          substituteInPlace meta.json \
            --replace-fail "protobuf<3.21.0" "protobuf"
        ''
        + lib.optionalString (lang == "zh") ''
          # Uses numpy 2.x, while the rest of the dependencies still uses
          # numpy 1.x. Remove once all spaCy packages are updated for
          # numpy 2.x.
          substituteInPlace meta.json \
            --replace-fail "spacy-pkuseg>=1.0.0,<2.0.0" "spacy-pkuseg"
        '';

      nativeBuildInputs = [ setuptools ] ++ lib.optionals requires-protobuf [ protobuf ];

      pythonImportsCheck = [ pname ];

      passthru.updateScript = writeScript "update-spacy-models" ''
        #!${stdenv.shell}
        set -eou pipefail
        PATH=${
          lib.makeBinPath [
            jq
            nix
            moreutils
          ]
        }

        IFS=. read -r major minor patch <<<"${spacy.version}"
        spacyVersion="$(echo "$major.$minor.0")"

        pushd pkgs/development/python-modules/spacy/ || exit

        jq -r '.[] | .pname' models.json | while IFS= read -r pname; do
          if [ "$(jq --arg pname "$pname" -r '.[] | select(.pname == $pname) | .version' models.json)" == "$spacyVersion" ]; then
            continue
          fi

          newHash="$(nix-prefetch-url "https://github.com/explosion/spacy-models/releases/download/$pname-$spacyVersion/$pname-$spacyVersion.tar.gz")"
          jq --arg newHash "$newHash" --arg pname "$pname" --arg spacyVersion "$spacyVersion" \
           '[(.[] | select(.pname != $pname)), (.[] | select(.pname == $pname) | .sha256 = $newHash | .version = $spacyVersion)] | sort_by(.pname)' \
           models.json | sponge models.json
        done

        popd || exit
      '';

      meta = {
        description = "Models for the spaCy NLP library";
        homepage = "https://github.com/explosion/spacy-models";
        license = lib.licenses.${license};
      };
    };

  makeModelSet =
    models: lib.listToAttrs (map (m: lib.nameValuePair m.pname (buildModelPackage m)) models);
in
makeModelSet (lib.importJSON ./models.json)
