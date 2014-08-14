{ pkgs,  stdenv, fetchurl, unzip, elasticsearch }:

with pkgs.lib;

let
  esPlugin = a@{
    pluginName, 
    installPhase ? ''
      mkdir -p $out
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
    pluginName = "jdbc";
    version = "1.2.1.1";
    src = fetchurl {
      url = "http://xbib.org/repository/org/xbib/elasticsearch/plugin/elasticsearch-river-jdbc/${version}/${name}-plugin.zip";
      sha1 = "68e7e1fdf45d0e5852b21610a84740595223ea11";
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
}
