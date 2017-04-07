{ pkgs,  stdenv, fetchurl, fetchFromGitHub, unzip, elasticsearch }:

with pkgs.lib;

let
  esPlugin = a@{
    pluginName,
    installPhase ? ''
      mkdir -p $out/bin
      ES_HOME=$out ${elasticsearch}/bin/elasticsearch-plugin --install ${pluginName} --url file://$src
    '',
    ...
  }:
    stdenv.mkDerivation (a // {
      inherit installPhase;
      unpackPhase = "true";
      buildInputs = [ unzip ];
      meta = a.meta // {
        platforms = elasticsearch.meta.platforms;
        maintainers = (a.meta.maintainers or []) ++ [ maintainers.offline ];
      };
    });
in {
  elasticsearch_river_jdbc = esPlugin rec {
    name = "elasticsearch-river-jdbc-${version}";
    pluginName = "elasticsearch-river-jdbc";
    version = "1.5.0.5";
    src = fetchurl {
      url = "http://xbib.org/repository/org/xbib/elasticsearch/plugin/elasticsearch-river-jdbc/${version}/${name}-plugin.zip";
      sha256 = "1p75l3vcnb90ar4j3dci2xf8dqnqyy31kc1r075fa2xqlsxgigcp";
    };
    meta = {
      homepage = "https://github.com/jprante/elasticsearch-river-jdbc";
      description = "Plugin to fetch data from JDBC sources for indexing into Elasticsearch";
      license = licenses.asl20;
    };
  };

  elasticsearch_analysis_lemmagen = esPlugin rec {
    name = "elasticsearch-analysis-lemmagen-${version}";
    pluginName = "elasticsearch-analysis-lemmagen";
    version = "0.1";
    src = fetchurl {
      url = "https://github.com/vhyza/elasticsearch-analysis-lemmagen/releases/download/v${version}/${name}-plugin.zip";
      sha256 = "bf7bf5ce3ccdd3afecd0e18cd6fce1ef56f824e41f4ef50553ae598caa5c366d";
    };
    meta = {
      homepage = "https://github.com/vhyza/elasticsearch-analysis-lemmagen";
      description = "LemmaGen Analysis plugin provides jLemmaGen lemmatizer as Elasticsearch token filter";
      license = licenses.asl20;
    };
  };

  elasticsearch_http_basic = stdenv.mkDerivation rec {
    name = "elasticsearch-http-basic-${version}";
    version = "1.5.0";

    src = fetchurl {
      url = "https://github.com/Asquera/elasticsearch-http-basic/releases/download/v${version}/${name}.jar";
      sha256 = "0fif6sbn2ich39lrgm039y9d5bxkylx9pvly04wss8rdhspvdskb";
    };

    phases = ["installPhase"];
    installPhase = "install -D $src $out/plugins/http-basic/${name}.jar";

    meta = {
      homepage = https://github.com/Asquera/elasticsearch-http-basic;
      description = "HTTP Basic Authentication for Elasticsearch";
      license = licenses.mit;
      platforms = elasticsearch.meta.platforms;
    };
  };

  elasticsearch_river_twitter = esPlugin rec {
    name = pname + "-" + version;
    pname = "elasticsearch-river-twitter";
    pluginName = "elasticsearch/" + pname + "/" + version;
    version = "2.5.0";

    src = fetchurl {
      url = "http://download.elasticsearch.org/elasticsearch/${pname}/${name}.zip";
      sha256 = "0851yrmyrpp6whyxk34ykcj7b28f90w0nvkrhvl49dwqgr5s4mn4";
    };

    meta = {
      homepage = "https://github.com/elasticsearch/elasticsearch-river-twitter";
      description = "Twitter River Plugin for ElasticSearch";
      license = licenses.asl20;
      maintainers = [ maintainers.edwtjo ];
      platforms = elasticsearch.meta.platforms;
    };
  };

  elasticsearch_kopf = esPlugin rec {
    name = "elasticsearch-kopf-${version}";
    pluginName = "elasticsearch-kopf";
    version = "1.5.7";
    src = fetchurl {
      url = "https://github.com/lmenezes/elasticsearch-kopf/archive/v${version}.zip";
      sha256 = "0mq6jmjb4ldi03m431kzr7ly0bf7mdim7s5dx4wplb85gyhscns1";
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
