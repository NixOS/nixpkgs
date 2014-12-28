{ pkgs,  stdenv, fetchurl, unzip, elasticsearch }:

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
    version = "1.3.0.4";
    src = fetchurl {
      url = "http://xbib.org/repository/org/xbib/elasticsearch/plugin/elasticsearch-river-jdbc/${version}/${name}-plugin.zip";
      sha256 = "0272l6cr032iccwwa803shzfjg3505jc48d9qdazrwxjmnlkkzqk";
    };
    meta = {
      homepage = "https://github.com/jprante/elasticsearch-river-jdbc";
      description = "Plugin to fetch data from JDBC sources for indexing into Elasticsearch";
      license = licenses.asl20;
    };
  };

  elasticsearch_analisys_lemmagen = esPlugin rec {
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
    version = "1.3.2";

    src = fetchurl {
      url = "https://github.com/Asquera/elasticsearch-http-basic/releases/download/${version}/${name}.jar";
      sha256 = "1qq8z0233mzz699zbzjwmx7ghn8k0djgyc5ixr8i5xchfrsrymn2";
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
    version = "2.3.0";

    src = fetchurl {
      url = "http://download.elasticsearch.org/elasticsearch/${pname}/${name}.zip";
      sha256 = "1lxxh1r61r15mzqyl0li37kcnn3vvpklnbfyys0kd6a1l82f0qvj";
    };

    meta = {
      homepage = "https://github.com/elasticsearch/elasticsearch-river-twitter";
      description = "Twitter River Plugin for ElasticSearch";
      license = licenses.asl20;
      maintainers = [ maintainers.edwtjo ];
      platforms = elasticsearch.meta.platforms;
    };

  };
}
