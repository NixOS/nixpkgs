{
  lib,
  stdenv,
  fetchurl,
  unzip,
  elasticsearch,
}:

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
      '',
      ...
    }:
    stdenv.mkDerivation (
      a
      // {
        inherit installPhase;
        pname = "elasticsearch-${pluginName}";
        dontUnpack = true;
        # Work around the "unpacker appears to have produced no directories"
        # case that happens when the archive doesn't have a subdirectory.
        sourceRoot = ".";
        nativeBuildInputs = [ unzip ];
        meta = a.meta // {
          platforms = elasticsearch.meta.platforms;
          maintainers = (a.meta.maintainers or [ ]) ++ (with lib.maintainers; [ offline ]);
        };
      }
    );
in
{

  analysis-icu = esPlugin rec {
    name = "elasticsearch-analysis-icu-${version}";
    pluginName = "analysis-icu";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${version}.zip";
      hash =
        if version == "7.17.27" then
          "sha256-HGHhcWj+6IWZ9kQCGJD7HmmvwqYV1zjN0tCsEpN4IAA="
        else
          throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = {
      homepage = "https://github.com/elastic/elasticsearch/tree/master/plugins/analysis-icu";
      description = "ICU Analysis plugin integrates the Lucene ICU module into elasticsearch";
      license = lib.licenses.asl20;
    };
  };

  analysis-kuromoji = esPlugin rec {
    pluginName = "analysis-kuromoji";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${version}.zip";
      hash =
        if version == "7.17.27" then
          "sha256-j0WXuGmE3bRNBnDx/uWxfWrIUrdatDt52ASj8m3mrVg="
        else
          throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = {
      homepage = "https://github.com/elastic/elasticsearch/tree/master/plugins/analysis-kuromoji";
      description = "Japanese (kuromoji) Analysis plugin integrates Lucene kuromoji analysis module into Elasticsearch";
      license = lib.licenses.asl20;
    };
  };

  analysis-lemmagen = esPlugin rec {
    pluginName = "analysis-lemmagen";
    version = esVersion;
    src = fetchurl {
      url = "https://github.com/vhyza/elasticsearch-${pluginName}/releases/download/v${version}/elasticsearch-${pluginName}-${version}-plugin.zip";
      hash =
        if version == "7.17.9" then
          "sha256-iY25apDkS6s0RoR9dVL2o/hFuUo6XhMzLjl8wDSFejk="
        else
          throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = {
      homepage = "https://github.com/vhyza/elasticsearch-analysis-lemmagen";
      description = "LemmaGen Analysis plugin provides jLemmaGen lemmatizer as Elasticsearch token filter";
      license = lib.licenses.asl20;
      broken = true; # Not released yet for ES 7.17.10
    };
  };

  analysis-phonetic = esPlugin rec {
    pluginName = "analysis-phonetic";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${version}.zip";
      hash =
        if version == "7.17.27" then
          "sha256-X8b8z9LznJQ24aF9GugRuDz1c9buqT7QGS3jhuDbYBM="
        else
          throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = {
      homepage = "https://github.com/elastic/elasticsearch/tree/master/plugins/analysis-phonetic";
      description = "Phonetic Analysis plugin integrates phonetic token filter analysis with elasticsearch";
      license = lib.licenses.asl20;
    };
  };

  analysis-smartcn = esPlugin rec {
    pluginName = "analysis-smartcn";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${version}.zip";
      hash =
        if version == "7.17.27" then
          "sha256-0hHHkywdpjKqzZ9vFqQ9B2aLCky17AYzFcSiaz/zGSw="
        else
          throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = {
      homepage = "https://github.com/elastic/elasticsearch/tree/master/plugins/analysis-smartcn";
      description = "Smart Chinese Analysis plugin integrates Lucene Smart Chinese analysis module into Elasticsearch";
      license = lib.licenses.asl20;
    };
  };

  discovery-ec2 = esPlugin rec {
    pluginName = "discovery-ec2";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${version}.zip";
      hash =
        if version == "7.17.27" then
          "sha256-44p0Pn0mYKR5hWtC8jdaUbh9mbUGiHN9PK98ZT1jQFY="
        else
          throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = {
      homepage = "https://github.com/elastic/elasticsearch/tree/master/plugins/discovery-ec2";
      description = "EC2 discovery plugin uses the AWS API for unicast discovery";
      license = lib.licenses.asl20;
    };
  };

  ingest-attachment = esPlugin rec {
    pluginName = "ingest-attachment";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${version}.zip";
      hash =
        if version == "7.17.27" then
          "sha256-i+fGO7Ic2Wm/COfPGeRhiJ99Os+rLRYgs/pSepQr68g="
        else
          throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = {
      homepage = "https://github.com/elastic/elasticsearch/tree/master/plugins/ingest-attachment";
      description = "Ingest processor that uses Apache Tika to extract contents";
      license = lib.licenses.asl20;
    };
  };

  repository-s3 = esPlugin rec {
    pluginName = "repository-s3";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${esVersion}.zip";
      hash =
        if version == "7.17.27" then
          "sha256-o2T0Dd2RqVh99wDPJMEvpnEpFFjz0lQrN9yAVJfiSGY="
        else
          throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = {
      homepage = "https://github.com/elastic/elasticsearch/tree/master/plugins/repository-s3";
      description = "S3 repository plugin adds support for using AWS S3 as a repository for Snapshot/Restore";
      license = lib.licenses.asl20;
    };
  };

  repository-gcs = esPlugin rec {
    pluginName = "repository-gcs";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${esVersion}.zip";
      hash =
        if version == "7.17.27" then
          "sha256-CWyQuzf2fP9BSIUWL/jxkxrXwdvHyujEINDNhY3FKNI="
        else
          throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = {
      homepage = "https://github.com/elastic/elasticsearch/tree/master/plugins/repository-gcs";
      description = "GCS repository plugin adds support for using Google Cloud Storage as a repository for Snapshot/Restore";
      license = lib.licenses.asl20;
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
        if esVersion == "7.17.27" then
          "${esVersion}-53.10.0"
        else
          throw "unsupported version ${esVersion} for plugin ${pluginName}";
      src =
        if esVersion == "7.17.27" then
          fetchurl {
            url = "https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/${version}/search-guard-suite-plugin-${version}.zip";
            hash = "sha256-M1yJ8OD+mDq2uEiK6pvsMxUQMrg6o5A4xEPX8nDt1Rs=";
          }
        else
          throw "unsupported version ${version} for plugin ${pluginName}";
      meta = {
        homepage = "https://search-guard.com";
        description = "Elasticsearch plugin that offers encryption, authentication, and authorisation";
        license = lib.licenses.asl20;
      };
    };
}
