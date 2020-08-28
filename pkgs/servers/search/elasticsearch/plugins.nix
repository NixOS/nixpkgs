{ lib, stdenv, fetchurl, unzip, elasticsearch }:

let
  esVersion = elasticsearch.version;

  esPlugin = a@{
    pluginName,
    installPhase ? ''
      mkdir -p $out/config
      mkdir -p $out/plugins
      ln -s ${elasticsearch}/lib $out/lib
      ES_HOME=$out ${elasticsearch}/bin/elasticsearch-plugin install --batch -v file://$src
      rm $out/lib
    '',
    ...
  }:
    stdenv.mkDerivation (a // {
      inherit installPhase;
      pname = "elasticsearch-${pluginName}";
      dontUnpack = true;
      # Work around the "unpacker appears to have produced no directories"
      # case that happens when the archive doesn't have a subdirectory.
      setSourceRoot = "sourceRoot=$(pwd)";
      buildInputs = [ unzip ];
      meta = a.meta // {
        platforms = elasticsearch.meta.platforms;
        maintainers = (a.meta.maintainers or []) ++ (with lib.maintainers; [ offline ]);
      };
    });
in {

  analysis-icu = esPlugin rec {
    name = "elasticsearch-analysis-icu-${version}";
    pluginName = "analysis-icu";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${version}.zip";
      sha256 =
        if version == "7.8.1" then "0fa2nkz9hak12bzjvla047318d9k6ggqjqbkqxnvqgw18gvs9mrg"
        else if version == "6.8.3" then "0vbaqyj0lfy3ijl1c9h92b0nh605h5mjs57bk2zhycdvbw5sx2lv"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with stdenv.lib; {
      homepage = "https://github.com/elastic/elasticsearch/tree/master/plugins/analysis-icu";
      description = "The ICU Analysis plugin integrates the Lucene ICU module into elasticsearch";
      license = licenses.asl20;
    };
  };

  analysis-lemmagen = esPlugin rec {
    pluginName = "analysis-lemmagen";
    version = esVersion;
    src = fetchurl {
      url = "https://github.com/vhyza/elasticsearch-${pluginName}/releases/download/v${version}/elasticsearch-${pluginName}-${version}-plugin.zip";
      sha256 =
        if version == "7.8.1" then "17xq1mcfmc7msbxygmwzfxf6bhb1psxdlnh5vws1zpra75p1n9rz"
        else if version == "6.8.3" then "12bshvp01pp2lgwd0cn9l58axg8gdimsh4g9wfllxi1bdpv4cy53"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with lib; {
      homepage = "https://github.com/vhyza/elasticsearch-analysis-lemmagen";
      description = "LemmaGen Analysis plugin provides jLemmaGen lemmatizer as Elasticsearch token filter";
      license = licenses.asl20;
    };
  };

  analysis-phonetic = esPlugin rec {
    pluginName = "analysis-phonetic";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${version}.zip";
      sha256 =
        if version == "7.8.1" then "1qjmrvbq37bpwqbr88xfbbwl2iym9crpphs1nlmi8wzivpa1p98v"
        else if version == "6.8.3" then "0ggdhf7w50bxsffmcznrjy14b578fps0f8arg3v54qvj94v9jc37"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with lib; {
      homepage = "https://github.com/elastic/elasticsearch/tree/master/plugins/analysis-phonetic";
      description = "The Phonetic Analysis plugin integrates phonetic token filter analysis with elasticsearch";
      license = licenses.asl20;
    };
  };

  discovery-ec2 = esPlugin rec {
    pluginName = "discovery-ec2";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${version}.zip";
      sha256 =
        if version == "7.8.1" then "0d2vnh75v4gxgpasl8wddmpjd9mncf8wv3la9l956r76dcfxvdfd"
        else if version == "6.8.3" then "0pmffz761dqjpvmkl7i7xsyw1iyyspqpddxp89rjsznfc9pak5im"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with lib; {
      homepage = "https://github.com/elastic/elasticsearch/tree/master/plugins/discovery-ec2";
      description = "The EC2 discovery plugin uses the AWS API for unicast discovery.";
      license = licenses.asl20;
    };
  };

  ingest-attachment = esPlugin rec {
    pluginName = "ingest-attachment";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${version}.zip";
      sha256 =
        if version == "7.8.1" then "1j99lxjqnnlpr8n35ris0mqkyq4gravn2jw6fkpdxksx9s0vkh12"
        else if version == "6.8.3" then "0kfr4i2rcwinjn31xrc2piicasjanaqcgnbif9xc7lnak2nnzmll"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with lib; {
      homepage = "https://github.com/elastic/elasticsearch/tree/master/plugins/ingest-attachment";
      description = "Ingest processor that uses Apache Tika to extract contents";
      license = licenses.asl20;
    };
  };

  repository-s3 = esPlugin rec {
    pluginName = "repository-s3";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${esVersion}.zip";
      sha256 =
        if version == "7.8.1" then "1ffaqrwif5q15jq240q1j4rj1nh04vq97nymjls7x2l936is24rb"
        else if version == "6.8.3" then "1mm6hj2m1db68n81rzsvlw6nisflr5ikzk5zv9nmk0z641n5vh1x"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with lib; {
      homepage = "https://github.com/elastic/elasticsearch/tree/master/plugins/repository-s3";
      description = "The S3 repository plugin adds support for using AWS S3 as a repository for Snapshot/Restore.";
      license = licenses.asl20;
    };
  };

  repository-gcs = esPlugin rec {
    pluginName = "repository-gcs";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${esVersion}.zip";
      sha256 =
        if version == "7.8.1" then "055a5x91f20yf3q6rivj9md9hp27qgy6r9jmbf6ai6n6i3b7l8vs"
        else if version == "6.8.3" then "1s2klpvnhpkrk53p64zbga3b66czi7h1a13f58kfn2cn0zfavnbk"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with lib; {
      homepage = "https://github.com/elastic/elasticsearch/tree/master/plugins/repository-gcs";
      description = "The GCS repository plugin adds support for using Google Cloud Storage as a repository for Snapshot/Restore.";
      license = licenses.asl20;
    };
  };

  search-guard = let
    majorVersion = lib.head (builtins.splitVersion esVersion);
  in esPlugin rec {
    pluginName = "search-guard";
    version =
      # https://docs.search-guard.com/latest/search-guard-versions
      if esVersion == "7.5.1" then "${esVersion}-38.0.0"
      else if esVersion == "6.8.3" then "${esVersion}-25.5"
      else throw "unsupported version ${esVersion} for plugin ${pluginName}";
    src = fetchurl {
      url = "mirror://maven/com/floragunn/${pluginName}-${majorVersion}/${version}/${pluginName}-${majorVersion}-${version}.zip";
      sha256 =
        if version == "7.5.1-38.0.0" then "1a1wp9wrmz6ji2rnpk0b9jqnp86w0w0z8sb48giyc1gzcy1ra9yh"
        else if version == "6.8.3-25.5" then "0a7ys9qinc0fjyka03cx9rv0pm7wnvslk234zv5vrphkrj52s1cb"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with lib; {
      homepage = "https://search-guard.com";
      description = "Elasticsearch plugin that offers encryption, authentication, and authorisation. ";
      license = licenses.asl20;
    };
  };
}
