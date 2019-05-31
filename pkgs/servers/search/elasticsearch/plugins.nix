{ pkgs, lib, stdenv, fetchurl, unzip, javaPackages, elasticsearch }:

let
  esVersion = elasticsearch.version;

  majorVersion = lib.head (builtins.splitVersion esVersion);

  esPlugin = a@{
    pluginName,
    installPhase ? ''
      mkdir -p $out/config
      mkdir -p $out/plugins
      ln -s ${elasticsearch}/lib $out/lib
      ES_HOME=$out ${elasticsearch}/bin/elasticsearch-plugin install --batch -v file://$src
      rm $out/lib
    '',
    ...
  }:
    stdenv.mkDerivation (a // {
      inherit installPhase;
      unpackPhase = "true";
      buildInputs = [ unzip ];
      meta = a.meta // {
        platforms = elasticsearch.meta.platforms;
        maintainers = (a.meta.maintainers or []) ++ (with stdenv.lib.maintainers; [ offline ]);
      };
    });
in {

  analysis-lemmagen = esPlugin rec {
    name = "elasticsearch-analysis-lemmagen-${version}";
    pluginName = "elasticsearch-analysis-lemmagen";
    version = esVersion;
    src = fetchurl {
      url = "https://github.com/vhyza/${pluginName}/releases/download/v${version}/${name}-plugin.zip";
      sha256 =
        if version == "7.0.1" then "155zj9zw81msx976c952nk926ndav1zqhmy2xih6nr82qf0p71hm"
        else if version == "6.7.2" then "1r176ncjbilkmri2c5rdxh5xqsrn77m1f0p98zs47czwlqh230iq"
        else throw "unsupported version ${version} for plugin ${pluginName}";
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
    version = esVersion;
    src = pkgs.fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${version}.zip";
      sha256 =
        if version == "7.0.1" then "0nrvralh4fygs0ys2ikg3x08jdyh9276d5w7yfncbbi0xrg9hk6g"
        else if version == "6.7.2" then "1p0cdz3lfksfd2kvlcj0syxhbx27mimsaw8q4kgjpjjjwqayg523"
        else if version == "5.6.16" then "1300pfmnlpfm1hh2jgas8j2kqjqiqkxhr8czshj9lx0wl4ciknin"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with stdenv.lib; {
      homepage = https://github.com/elastic/elasticsearch/tree/master/plugins/discovery-ec2;
      description = "The EC2 discovery plugin uses the AWS API for unicast discovery.";
      license = licenses.asl20;
    };
  };

  repository-s3 = esPlugin rec {
    name = "elasticsearch-repository-s3-${version}";
    pluginName = "repository-s3";
    version = esVersion;
    src = pkgs.fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${esVersion}.zip";
      sha256 =
        if version == "7.0.1" then "17bf8m1q92j5yhgldckl4hlsfv6qgwwqdc1da9kzgidgky7jwkbc"
        else if version == "6.7.2" then "1l353zfyv3qziz8xkann9cbzx4wj5s14wnknfw351j6vgdq26l12"
        else if version == "5.6.16" then "0k3li5xv1270ygb9lqk6ji3nngngl2im3z38k08nd627vxdrzij2"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with stdenv.lib; {
      homepage = https://github.com/elastic/elasticsearch/tree/master/plugins/repository-s3;
      description = "The S3 repository plugin adds support for using AWS S3 as a repository for Snapshot/Restore.";
      license = licenses.asl20;
    };
  };

  repository-gcs = esPlugin rec {
    name = "elasticsearch-repository-gcs-${version}";
    pluginName = "repository-gcs";
    version = esVersion;
    src = pkgs.fetchurl {
      url = "https://artifacts.elastic.co/downloads/elasticsearch-plugins/${pluginName}/${pluginName}-${esVersion}.zip";
      sha256 =
        if version == "7.0.1" then "0a3rc2gggsj7xfncil1s53dmq799lcm82h0yncs94jnb182sbmzc"
        else if version == "6.7.2" then "0afccbvb7x6y3nrwmal09vpgxyz4lar6lffw4mngalcppsk8irvv"
        else if version == "5.6.16" then "0hwqx4yhdn4c0ccdpvgrg30ag8hy3mgxgk7h7pibdmzvy7qw7501"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with stdenv.lib; {
      homepage = https://github.com/elastic/elasticsearch/tree/master/plugins/repository-gcs;
      description = "The GCS repository plugin adds support for using Google Cloud Storage as a repository for Snapshot/Restore.";
      license = licenses.asl20;
    };
  };

  search-guard = let
    majorVersion = lib.head (builtins.splitVersion esVersion);
  in esPlugin rec {
    name = "elasticsearch-search-guard-${version}";
    pluginName = "search-guard";
    version =
      if esVersion == "7.0.1" then "${esVersion}-35.0.0"
      else if esVersion == "6.7.2" then "${esVersion}-25.1"
      else if esVersion == "5.6.16" then "${esVersion}-19.3"
      else throw "unsupported version ${esVersion} for plugin ${pluginName}";
    src = fetchurl {
      url = "mirror://maven/com/floragunn/${pluginName}-${majorVersion}/${version}/${pluginName}-${majorVersion}-${version}.zip";
      sha256 =
        if version == "7.0.1-35.0.0" then "0wsiqq7j7ph9g2vhhvjmwrh5a2q1wzlysgr75gc35zcvqz6cq8ha"
        else if version == "6.7.2-25.1" then "119r1zibi0z40mfxrpkx0zzay0yz6c7syqmmw8i2681wmz4nksda"
        else if version == "5.6.16-19.3" then "1q70anihh89c53fnk8wlq9z5dx094j0f9a0y0v2zsqx18lz9ikmx"
        else throw "unsupported version ${version} for plugin ${pluginName}";
    };
    meta = with stdenv.lib; {
      homepage = https://github.com/floragunncom/search-guard;
      description = "Elasticsearch plugin that offers encryption, authentication, and authorisation. ";
      license = licenses.asl20;
    };
  };
}
