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
<<<<<<< HEAD
      sourceRoot = ".";
=======
      setSourceRoot = "sourceRoot=$(pwd)";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      hash =
        if version == "7.17.10" then "sha256-D08CVW/qHpZZaKnploM4aCJ4bunvPjVmieDYr1d6jQA="
=======
      sha256 =
        if version == "7.17.4" then "a4e881d86694ae70ab6b18f72ea700415971200145d33d438e57c0374d9fc16f"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with lib; {
      homepage = "https://github.com/elastic/elasticsearch/tree/master/plugins/analysis-icu";
      description = "The ICU Analysis plugin integrates the Lucene ICU module into elasticsearch";
      license = licenses.asl20;
    };
  };

  analysis-kuromoji = esPlugin rec {
    pluginName = "analysis-kuromoji";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${version}.zip";
<<<<<<< HEAD
      hash =
        if version == "7.17.10" then "sha256-cpgr2zPCpsLrmshWJWoGNcGl0X+bO/K4A9bMqLv8+H8="
=======
      sha256 =
        if version == "7.17.4" then "sha256-O6GCTwuxRrFFht9pQGg8G0O8wrFP2YnSaG02yy7NZ6I="
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with lib; {
      homepage = "https://github.com/elastic/elasticsearch/tree/master/plugins/analysis-kuromoji";
      description = "The Japanese (kuromoji) Analysis plugin integrates Lucene kuromoji analysis module into Elasticsearch.";
      license = licenses.asl20;
    };
  };

  analysis-lemmagen = esPlugin rec {
    pluginName = "analysis-lemmagen";
    version = esVersion;
    src = fetchurl {
      url = "https://github.com/vhyza/elasticsearch-${pluginName}/releases/download/v${version}/elasticsearch-${pluginName}-${version}-plugin.zip";
<<<<<<< HEAD
      hash =
        if version == "7.17.9" then "sha256-iY25apDkS6s0RoR9dVL2o/hFuUo6XhMzLjl8wDSFejk="
=======
      sha256 =
        if version == "7.17.4" then "sha256-5tg4Lts++kL3QEnP+TM7NGR3EQH17H3KmhGHuhIGVqU="
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with lib; {
      homepage = "https://github.com/vhyza/elasticsearch-analysis-lemmagen";
      description = "LemmaGen Analysis plugin provides jLemmaGen lemmatizer as Elasticsearch token filter";
      license = licenses.asl20;
<<<<<<< HEAD
      broken = true; # Not released yet for ES 7.17.10
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  analysis-phonetic = esPlugin rec {
    pluginName = "analysis-phonetic";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${version}.zip";
<<<<<<< HEAD
      hash =
        if version == "7.17.10" then "sha256-UmykO+hZDvlFhEbf7zL2bdw4j6NhByRBu9eH3F6/EtM="
=======
      sha256 =
        if version == "7.17.4" then "1c8175b2dac54277c1f41981fb4a784829e74e6e74268381fe0c27bc6652704b"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      hash =
        if version == "7.17.10" then "sha256-Y/AbLfHSdocX0NQbnKm63gTWgwzssb4kpSwRqLozD9w="
=======
      sha256 =
        if version == "7.17.4" then "702e446997bde5cb38af120a1cb4271d976fdd23444be49e53b6be3801d845a9"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      hash =
        if version == "7.17.10" then "sha256-QIYD7cGpJQg+csv/tekN6GFtdnuhYU6VyAXk7nY/uWs="
=======
      sha256 =
        if version == "7.17.4" then "7d1574a585a9db0988ee248159d51f62cce5578a8c082096ef3e26efdb24aee7"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      hash =
        if version == "7.17.10" then "sha256-L8lS+EPYuhNNTnP3ImeZsBQ5a5DAncs3qBFDWGWISRI="
=======
      sha256 =
        if version == "7.17.4" then "cad923a662db705d40ca29698aa118e9e4cc50ae564c426a76d5acb777a4f57c"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      hash =
        if version == "7.17.10" then "sha256-eXstbxlyS8WzW8u5YiMFXGpILCcEWrIb/IxXVzAGFLU="
=======
      sha256 =
        if version == "7.17.4" then "a50be4cea5c68ad7615f87d672ba160d027fdfde2be0578bb2dabd6384cc8108"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      if esVersion == "7.17.10" then "${esVersion}-53.7.0"
      else throw "unsupported version ${esVersion} for plugin ${pluginName}";
    src =
      if esVersion == "7.17.10" then
        fetchurl {
          url = "https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/${version}/search-guard-suite-plugin-${version}.zip";
          hash = "sha256-FIF4O8z0U2giXVA2cNEdCDbpuJDJhaxHBOmv2fACucw=";
=======
      if esVersion == "7.17.4" then "${esVersion}-53.4.0"
      else throw "unsupported version ${esVersion} for plugin ${pluginName}";
    src =
      if esVersion == "7.17.4" then
        fetchurl {
          url = "https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/${version}/search-guard-suite-plugin-${version}.zip";
          sha256 = "sha256-PIRzhkxYryAiPjdjAXeV+g+O4YmQ1oV31m2GMC1PXu0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        }
      else throw "unsupported version ${version} for plugin ${pluginName}";
    meta = with lib; {
      homepage = "https://search-guard.com";
      description = "Elasticsearch plugin that offers encryption, authentication, and authorisation.";
      license = licenses.asl20;
    };
  };
}
