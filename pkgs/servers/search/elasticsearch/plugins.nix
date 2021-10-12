{ lib, stdenv, fetchurl, unzip, elasticsearch }:

let
  esVersion = elasticsearch.version;

  esPlugin =
    a@{ pluginName
    , installPhase ? ''
        mkdir -p $out/config
        mkdir -p $out/plugins
        ln -s ${elasticsearch}/lib $out/lib
        ES_HOME=$out ${elasticsearch}/bin/elasticsearch-plugin install --batch -v file://$src
        rm $out/lib
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
        if version == "7.10.2" then "sha256-HXNJy8WPExPeh5afjdLEFg+0WX0LYI/kvvaLGVUke5E="
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
        if version == "7.10.2" then "sha256-mW4YNZ20qatyfHCDAmod/gVmkPYh15NrsYPgiBy1/T8="
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
        if version == "7.10.2" then "sha256-PjA/pwoulkD2d6sHKqzcYxQpb1aS68/l047z5JTcV3Y="
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
        if version == "7.10.2" then "sha256-yvxSkVyZDWeu7rcxxq1+IVsljZQKgWEURiXY9qycK1s="
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
        if version == "7.10.2" then "sha256-yOMiYJ2c/mcLDcTA99YrpQBiEBAa/mLtTqJlqTJ5tBc="
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
        if version == "7.10.2" then "sha256-fN2RQsY9OACE71pIw87XVJo4c3sUu/6gf/6wUt7ZNIE="
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
        if version == "7.10.2" then "sha256-JdWt5LzSbs0MIEuLJIE1ceTnNeTYI5Jt2N0Xj7OBO6g="
        else if version == "6.8.3" then "1s2klpvnhpkrk53p64zbga3b66czi7h1a13f58kfn2cn0zfavnbk"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with lib; {
      homepage = "https://github.com/elastic/elasticsearch/tree/master/plugins/repository-gcs";
      description = "The GCS repository plugin adds support for using Google Cloud Storage as a repository for Snapshot/Restore.";
      license = licenses.asl20;
    };
  };

  search-guard =
    let
      majorVersion = lib.head (builtins.splitVersion esVersion);
    in
    esPlugin rec {
      pluginName = "search-guard";
      version =
        # https://docs.search-guard.com/latest/search-guard-versions
        if esVersion == "7.10.2" then "7.10.1-49.3.0"
        else if esVersion == "6.8.3" then "${esVersion}-25.5"
        else throw "unsupported version ${esVersion} for plugin ${pluginName}";
      src = fetchurl {
        url =
          if version == "7.10.1-49.3.0" then "https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/${version}/search-guard-suite-plugin-${version}.zip"
          else "mirror://maven/com/floragunn/${pluginName}-${majorVersion}/${version}/${pluginName}-${majorVersion}-${version}.zip";
        sha256 =
          if version == "7.10.1-49.3.0" then "sha256-vKH2+c+7WlncgljrvYH9lAqQTKzg9l0ABZ23Q/xdoK4="
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
