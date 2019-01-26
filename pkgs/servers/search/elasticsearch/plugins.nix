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
      sha256 = "0299ldqwjn1gn44yyjiqjrxvs6mlclhzl1dbn6xlgg1a2lkaal4v";
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
      sha256 = "1mg9knbc4r21kaiqnmkd8nzf2i23w5zxqnxyz484q0l2jf4hlkq1";
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
    version = "${elk6Version}-23.2";
    src = fetchurl rec {
      url = "mirror://maven/com/floragunn/search-guard-6/${version}/search-guard-6-${version}.zip";
      sha256 = "05310wyxzhylxr0dfgzr10pb0pak30ry8r97g49n6iqj8dw3csnb";
    };
    meta = with stdenv.lib; {
      homepage = https://github.com/floragunncom/search-guard;
      description = "Plugin to fetch data from JDBC sources for indexing into Elasticsearch";
      license = licenses.asl20;
    };
  };
}
