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
      setSourceRoot = "sourceRoot=$(pwd)";
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
      sha256 =
        if version == "7.16.1" then "1sz858m9963xqr5kzjlwnq7k0a146rn60v6xijyfbp8y3brg618p"
        else if version == "6.8.21" then "06b1pavyggzfp4wwdql0q9nm3r7i9px9cagp4yh4nhxhnk4w5fiq"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with lib; {
      homepage = "https://github.com/elastic/elasticsearch/tree/master/plugins/analysis-icu";
      description = "The ICU Analysis plugin integrates the Lucene ICU module into elasticsearch";
      license = licenses.asl20;
    };
  };

  analysis-lemmagen = esPlugin rec {
    pluginName = "analysis-lemmagen";
    version = esVersion;
    src = fetchurl {
      url = "https://github.com/vhyza/elasticsearch-${pluginName}/releases/download/v${version}/elasticsearch-${pluginName}-${version}-plugin.zip";
      sha256 =
        if version == "7.16.1" then "0yjy9yhw77lmalivxnmv2rq8fk93ddxszkk73lgmpffladx2ikir"
        else if version == "6.8.21" then "0m80cn7vkcvk95v4pdmi6vk5ww7p01k0hj2iqb9g870vs6x2qjzv"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with lib; {
      homepage = "https://github.com/vhyza/elasticsearch-analysis-lemmagen";
      description = "LemmaGen Analysis plugin provides jLemmaGen lemmatizer as Elasticsearch token filter";
      license = licenses.asl20;
    };
  };

  analysis-phonetic = esPlugin rec {
    pluginName = "analysis-phonetic";
    version = esVersion;
    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${version}.zip";
      sha256 =
        if version == "7.16.1" then "1w5ndgffqzj5ijglmykifrk1jsgh7qwn8m7sbpiv0r7n3aayhz1x"
        else if version == "6.8.21" then "07w8s4a5gvr9lzjzf629y8rx3kvs6zd1vl07ksw1paghp42yb354"
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
      sha256 =
        if version == "7.16.1" then "16mv7b9nl96bcygabvjqidxp2sjk340va19mrmliblpq3mxa2sii"
        else if version == "6.8.21" then "1kdpbrasxwr3dn21zjrklp1s389rwa51fairygdwl8px9liwwfa5"
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
      sha256 =
        if version == "7.16.1" then "0bf8f8cybsp6s2ai3j04yay9kbhsafpgxivxjvzn2iy9qgc84ls4"
        else if version == "6.8.21" then "0v31yyhjcdlqnjw1f9kihh7z3c6d31whc57hqqd1dn579n4s9rlz"
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
      sha256 =
        if version == "7.16.1" then "0sfa0ql3hh8jmha230dyhr51bvsvwmazyycf36ngpmxsysm8ccml"
        else if version == "6.8.21" then "0sfh1az30q4f34zxig2fz8wn9gk53fmmxyg5pbi1svn9761p5awq"
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
      sha256 =
        if version == "7.16.1" then "1b95hjr4qhiavm7r7k19bwk5c64r00f1g5s0ydnb6gzym9hdb5s1"
        else if version == "6.8.21" then "00lwj00rfdk6850gk1n86chiz2w6afpqn7jn588jdbwv41qh5mrv"
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
      if esVersion == "7.16.1" then "${esVersion}-52.5.0"
      else if esVersion == "6.8.21" then "${esVersion}-25.6"
      else throw "unsupported version ${esVersion} for plugin ${pluginName}";
    src =
      if esVersion == "7.16.1" then
        fetchurl {
          url = "https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/${version}/search-guard-suite-plugin-${version}.zip";
          sha256 = "1m3nj35qyrkkh3mhmn66nippavima8h8qpaxddalhjsvf70lhnjb";
        }
      else if esVersion == "6.8.21" then
        fetchurl {
          url = "https://maven.search-guard.com/search-guard-release/com/floragunn/search-guard-6/${version}/search-guard-6-${version}.zip";
          sha256 = "19nj513wigwd0mzq747zax4fzvv5vi24f7j0636rydd9iv9cyhg2";
        }
      else throw "unsupported version ${version} for plugin ${pluginName}";
    meta = with lib; {
      homepage = "https://search-guard.com";
      description = "Elasticsearch plugin that offers encryption, authentication, and authorisation.";
      license = licenses.asl20;
    };
  };
}
