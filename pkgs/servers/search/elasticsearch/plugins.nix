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
    version = "6.7.1"; # elk6Version;
    src = fetchurl {
      url = "https://github.com/vhyza/elasticsearch-analysis-lemmagen/releases/download/v${version}/${name}-plugin.zip";
      sha256 = "0mf8lpf40bjpzfj9lkhrg7c3xinzvg7aby3vd6h92g9i676xs8ri";
    };
    meta = with stdenv.lib; {
      homepage = https://github.com/vhyza/elasticsearch-analysis-lemmagen;
      description = "LemmaGen Analysis plugin provides jLemmaGen lemmatizer as Elasticsearch token filter";
      license = licenses.asl20;
      # TODO: remove the following when there's a release compatible with elasticsearch-6.7.2.
      # See: https://github.com/vhyza/elasticsearch-analysis-lemmagen/issues/14
      broken = true;
    };
  };

  discovery-ec2 = esPlugin rec {
    name = "elasticsearch-discovery-ec2-${version}";
    pluginName = "discovery-ec2";
    version = "${elk6Version}";
    src = pkgs.fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/discovery-ec2/discovery-ec2-${elk6Version}.zip";
      sha256 = "1p0cdz3lfksfd2kvlcj0syxhbx27mimsaw8q4kgjpjjjwqayg523";
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
    version = "${elk6Version}-25.1";
    src = fetchurl rec {
      url = "mirror://maven/com/floragunn/search-guard-6/${version}/search-guard-6-${version}.zip";
      sha256 = "119r1zibi0z40mfxrpkx0zzay0yz6c7syqmmw8i2681wmz4nksda";
    };
    meta = with stdenv.lib; {
      homepage = https://github.com/floragunncom/search-guard;
      description = "Plugin to fetch data from JDBC sources for indexing into Elasticsearch";
      license = licenses.asl20;
    };
  };
}
