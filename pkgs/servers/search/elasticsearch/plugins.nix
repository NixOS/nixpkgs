{ pkgs,  stdenv, fetchurl, unzip, elasticsearch-oss, javaPackages, elk6Version }:

let
  esPlugin = a@{
    pluginName,
    installPhase ? ''
      mkdir -p $out/config
      mkdir -p $out/plugins
      ES_HOME=$out ${elasticsearch-oss}/bin/elasticsearch-plugin install --batch -v file://$src
    '',
    ...
  }:
    stdenv.mkDerivation (a // {
      inherit installPhase;
      unpackPhase = "true";
      buildInputs = [ unzip ];
      meta = a.meta // {
        platforms = elasticsearch-oss.meta.platforms;
        maintainers = (a.meta.maintainers or []) ++ (with stdenv.lib.maintainers; [ offline ]);
      };
    });
in {

  elasticsearch_analysis_lemmagen = esPlugin rec {
    name = "elasticsearch-analysis-lemmagen-${version}";
    pluginName = "elasticsearch-analysis-lemmagen";
    version = "${elk6Version}";
    src = fetchurl {
      url = "https://github.com/vhyza/elasticsearch-analysis-lemmagen/releases/download/v${version}/${name}-plugin.zip";
      sha256 = "1ldmz1a4g3rr4djk17yjx9slfmqx0if4i725465d1yvd740ka8hi";
    };
    meta = with stdenv.lib; {
      homepage = https://github.com/vhyza/elasticsearch-analysis-lemmagen;
      description = "LemmaGen Analysis plugin provides jLemmaGen lemmatizer as Elasticsearch token filter";
      license = licenses.asl20;
    };
  };

  discovery-ec2 = esPlugin rec {
    name = "elasticsearch-discovery-ec2-${version}";
    pluginName = "discovery-ec2";
    version = "${elk6Version}";
    src = pkgs.fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/discovery-ec2/discovery-ec2-${elk6Version}.zip";
      sha256 = "0179qixwi71jn5bmj03p80x8318pxbcf9asxgjly9j4z49w9r2c0";
    };
    meta = with stdenv.lib; {
      homepage = https://github.com/elastic/elasticsearch/tree/master/plugins/discovery-ec2;
      description = "The EC2 discovery plugin uses the AWS API for unicast discovery.";
      license = licenses.asl20;
    };
  };

  search_guard = esPlugin rec {
    name = "elastic-search-guard-${version}";
    pluginName = "search-guard";
    version = "${elk6Version}-24.2";
    src = fetchurl rec {
      url = "mirror://maven/com/floragunn/search-guard-6/${version}/search-guard-6-${version}.zip";
      sha256 = "17kp8damya95lsjc58s9818xi8387j3hj2ivq09j5l4il100d6jl";
    };
    meta = with stdenv.lib; {
      homepage = https://github.com/floragunncom/search-guard;
      description = "Plugin to fetch data from JDBC sources for indexing into Elasticsearch";
      license = licenses.asl20;
    };
  };
}
