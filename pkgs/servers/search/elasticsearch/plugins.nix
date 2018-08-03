{ pkgs,  stdenv, fetchurl, unzip, elasticsearch-oss, javaPackages, elk6Version }:

with pkgs.lib;

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
        maintainers = (a.meta.maintainers or []) ++ [ maintainers.offline ];
      };
    });
in {

  elasticsearch_analysis_lemmagen = esPlugin rec {
    name = "elasticsearch-analysis-lemmagen-${version}";
    pluginName = "elasticsearch-analysis-lemmagen";
    version = "0.1";
    src = fetchurl {
      url = "https://github.com/vhyza/elasticsearch-analysis-lemmagen/releases/download/v${version}/${name}-plugin.zip";
      sha256 = "bf7bf5ce3ccdd3afecd0e18cd6fce1ef56f824e41f4ef50553ae598caa5c366d";
    };
    meta = {
      homepage = https://github.com/vhyza/elasticsearch-analysis-lemmagen;
      description = "LemmaGen Analysis plugin provides jLemmaGen lemmatizer as Elasticsearch token filter";
      license = licenses.asl20;
    };
  };


  elasticsearch_kopf = esPlugin rec {
    name = "elasticsearch-kopf-${version}";
    pluginName = "elasticsearch-kopf";
    version = "2.1.1";
    src = fetchurl {
      url = "https://github.com/lmenezes/elasticsearch-kopf/archive/v${version}.zip";
      sha256 = "1nwwd92g0jxhfpkxb1a9z5a62naa1y7hvlx400dm6mwwav3mrf4v";
    };
    meta = {
      homepage = https://github.com/lmenezes/elasticsearch-kopf;
      description = "Web administration tool for ElasticSearch";
      license = licenses.mit;
    };
  };

  search_guard = esPlugin rec {
    name = "elastic-search-guard-${version}";
    pluginName = "search-guard";
    version = "0.5";
    src = fetchurl {
      url = "https://github.com/floragunncom/search-guard/releases/download/v${version}/${pluginName}-${version}.zip";
      sha256 = "1zima4jmq1rrcqxhlrp2xian80vp244d2splby015n5cgqrp39fl";
    };
    meta = {
      homepage = https://github.com/floragunncom/search-guard;
      description = "Plugin to fetch data from JDBC sources for indexing into Elasticsearch";
      license = licenses.asl20;
    };
  };
}
