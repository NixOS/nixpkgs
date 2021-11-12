{ lib, stdenv, fetchurl, unzip, elasticsearch }:

let
  esVersion = elasticsearch.version;

  esPlugin =
    a@{
      pluginName,
      installPhase ? ''
        mkdir -p $out/config
        mkdir -p $out/plugins
        ln -s ${elasticsearch}/lib ${elasticsearch}/modules $out
        ES_HOME=$out ${elasticsearch}/bin/elasticsearch-plugin install --batch -v file://$src
        rm $out/lib $out/modules
      ''
    , ...
    }:
    stdenv.mkDerivation (a // {
      inherit installPhase;
      pname = "elasticsearch-${pluginName}";
      dontUnpack = true;
      # Work around the "unpacker appears to have produced no directories"
      # case that happens when the archive doesn't have a subdirectory.
      setSourceRoot = "sourceRoot=$(pwd)";
      nativeBuildInputs = [ unzip ];
      meta = a.meta // {
        platforms = elasticsearch.meta.platforms;
        maintainers = (a.meta.maintainers or [ ]) ++ (with lib.maintainers; [ offline ]);
      };
    });
in
{

  analysis-icu = esPlugin rec {
    name = "elasticsearch-analysis-icu-${version}";
    pluginName = "analysis-icu";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${version}.zip";
      sha256 =
        if version == "7.11.1" then "0mi6fmnjbqypa4n1w34dvlmyq793pz4wf1r5srcs7i84kkiddysy"
        else if version == "6.8.3" then "0vbaqyj0lfy3ijl1c9h92b0nh605h5mjs57bk2zhycdvbw5sx2lv"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with lib; {
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
        if version == "7.11.1" then "0r2k2ndgqiqh27lch8dbay1m09f00h5kjcan87chcvyf623l40a3"
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
        if version == "7.11.1" then "10ln81zyf04qi9wv10mck8iz0xwfvwp4ni0hl1gkgvh44lf1n855"
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
        if version == "7.11.1" then "09grfvqjmm2rznc48z84awh54afh81qa16amfqw3amsb8dr6czm6"
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
        if version == "7.11.1" then "0imkf3w2fmspb78vkf9k6kqx1crm4f82qgnbk1qa7gbsa2j47hbs"
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
        if version == "7.11.1" then "0ahyb1plgwvq22id2kcx9g076ybb3kvybwakgcvsdjjdyi4cwgjs"
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
        if version == "7.11.1" then "0i98b905k1zwm3y9pfhr40v2fm5qdsp3icygibhxf7drffygk4l7"
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
      if esVersion == "7.11.1" then "${esVersion}-50.0.0"
      else if esVersion == "6.8.3" then "${esVersion}-25.5"
      else throw "unsupported version ${esVersion} for plugin ${pluginName}";
    src =
      if esVersion == "7.11.1" then
        fetchurl {
          url = "https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/${version}/search-guard-suite-plugin-${version}.zip";
          sha256 = "1lippygiy0xcxxlakylhvj3bj2i681k6jcfjsprkfk7hlaqsqxkm";
        }
      else if esVersion == "6.8.3" then
        fetchurl {
          url = "mirror://maven/com/floragunn/${pluginName}-${majorVersion}/${version}/${pluginName}-${majorVersion}-${version}.zip";
          sha256 = "0a7ys9qinc0fjyka03cx9rv0pm7wnvslk234zv5vrphkrj52s1cb";
        }
      else throw "unsupported version ${version} for plugin ${pluginName}";
    meta = with lib; {
      homepage = "https://search-guard.com";
      description = "Elasticsearch plugin that offers encryption, authentication, and authorisation. ";
      license = licenses.asl20;
    };
  };
}
