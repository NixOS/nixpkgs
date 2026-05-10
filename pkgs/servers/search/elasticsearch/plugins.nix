{
  lib,
  config,
  stdenv,
  fetchurl,
  unzip,
  bash,
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
        ES_HOME=$out ${bash}/bin/bash ${elasticsearch}/bin/elasticsearch-plugin install --batch -v file://$src
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
        nativeBuildInputs = [
          unzip
          bash
        ];
        meta = a.meta // {
          platforms = elasticsearch.meta.platforms;
          maintainers = a.meta.maintainers or [ ];
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
        if version == "9.4.0" then
          "sha256-EdZPrnPAfSCMSLKNX1vnxRyCLtnOf6ckHQuQfSaWcAM="
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
        if version == "9.4.0" then
          "sha256-4P9/QX6nSgKOLA3i5+co1/7TfuRrdCULYGZWm18tRy0="
        else
          throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = {
      homepage = "https://github.com/elastic/elasticsearch/tree/master/plugins/analysis-kuromoji";
      description = "Japanese (kuromoji) Analysis plugin integrates Lucene kuromoji analysis module into Elasticsearch";
      license = lib.licenses.asl20;
    };
  };

  analysis-phonetic = esPlugin rec {
    pluginName = "analysis-phonetic";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${version}.zip";
      hash =
        if version == "9.4.0" then
          "sha256-X/CtIbveQG8OHqbYEaPz3rGjNRQKE9/kzyZ49qedQDM="
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
        if version == "9.4.0" then
          "sha256-DPBIGoA75+QBXEW7Q5m5yrNF3uDdx5f3xK3+Aj+hx0s="
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
        if version == "9.4.0" then
          "sha256-2N7joWUchvv14g1LIUPl/FYy9bCyYQ9S0IJwXzXBIrQ="
        else
          throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = {
      homepage = "https://github.com/elastic/elasticsearch/tree/master/plugins/discovery-ec2";
      description = "EC2 discovery plugin uses the AWS API for unicast discovery";
      license = lib.licenses.asl20;
    };
  };

}
// lib.optionalAttrs config.allowAliases {
  analysis-lemmagen = throw "elasticsearchPlugins.analysis-lemmagen has been removed due to being broken for more than a year; see RFC 180"; # Added 2026-02-05
  ingest-attachment = throw "elasticsearchPlugins.ingest-attachment was merged into Elasticsearch core in 8.0 and no longer ships separately."; # Added 2026-05-09
  repository-gcs = throw "elasticsearchPlugins.repository-gcs was merged into Elasticsearch core in 8.0 and no longer ships separately."; # Added 2026-05-09
  repository-s3 = throw "elasticsearchPlugins.repository-s3 was merged into Elasticsearch core in 8.0 and no longer ships separately."; # Added 2026-05-09
  search-guard = throw "elasticsearchPlugins.search-guard does not yet have a release compatible with Elasticsearch ${esVersion}; latest Search Guard FLX supports up to 9.3.x."; # Added 2026-05-12
}
