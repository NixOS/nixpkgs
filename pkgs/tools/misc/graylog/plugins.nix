{ pkgs,  stdenv, fetchurl, fetchFromGitHub, unzip, graylog }:

with pkgs.lib;

let
  glPlugin = a@{
    pluginName,
    version,
    installPhase ? ''
      mkdir -p $out/bin
      cp $src $out/bin/${pluginName}-${version}.jar
    '',
    ...
  }:
    stdenv.mkDerivation (a // {
      inherit installPhase;
      unpackPhase = "true";
      buildInputs = [ unzip ];
      meta = a.meta // {
        platforms = graylog.meta.platforms;
        maintainers = (a.meta.maintainers or []) ++ [ maintainers.fadenb ];
      };
    });
in {
  auth_sso = glPlugin rec {
    name = "graylog-auth-sso-${version}";
    pluginName = "graylog-plugin-auth-sso";
    version = "1.0.6";
    src = fetchurl {
      url = "https://github.com/Graylog2/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "0wvdf2rnjrhdw1vp7bc7008s45rggzq57lh8k6s3q35rppligaqd";
    };
    meta = {
      homepage = https://github.com/Graylog2/graylog-plugin-auth-sso;
      description = "SSO support for Graylog through trusted HTTP headers set by load balancers or authentication proxies";
    };
  };
  internal-logs = glPlugin rec {
    name = "graylog-internal-logs-${version}";
    pluginName = "graylog-plugin-internal-logs";
    version = "1.0.0";
    src = fetchurl {
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "1abl7wwr59k9vvr2fmrlrx4ipsjjl8xryqy19fy5irxhpwp93ixl";
    };
    meta = {
      homepage = https://github.com/graylog-labs/graylog-plugin-internal-logs;
      description = "Graylog plugin to record internal logs of Graylog efficiently instead of sending them over the network";
    };
  };
  ipanonymizer = glPlugin rec {
    name = "graylog-ipanonymizer-${version}";
    pluginName = "graylog-plugin-ipanonymizer";
    version = "1.1.2";
    src = fetchurl {
      url = "https://github.com/Graylog2/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "0hd66751hp97ddkn29s1cmjmc2h1nrp431bq7d2wq16iyxxlygri";
    };
    meta = {
      homepage = https://github.com/Graylog2/graylog-plugin-ipanonymizer;
      description = "A graylog-server plugin that replaces the last octet of IP addresses in messages with xxx";
    };
  };
  jabber = glPlugin rec {
    name = "graylog-jabber-${version}";
    pluginName = "graylog-plugin-jabber";
    version = "1.2.1";
    src = fetchurl {
      url = "https://github.com/Graylog2/${pluginName}/releases/download/v${version}/${pluginName}-${version}.jar";
      sha256 = "1r12hpjp2ggmhsapgrk829va94aw44qi2kqqkgf1fj9ih4k0c837";
    };
    meta = {
      homepage = https://github.com/Graylog2/graylog-plugin-jabber;
      description = "Jabber Alarmcallback Plugin for Graylog";
    };
  };
  mongodb-profiler = glPlugin rec {
    name = "graylog-mongodb-profiler-${version}";
    pluginName = "graylog-plugin-mongodb-profiler";
    version = "2.0.1";
    src = fetchurl {
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "1hadxyawdz234lal3dq5cy3zppl7ixxviw96iallyav83xyi23i8";
    };
    meta = {
      homepage = https://github.com/graylog-labs/graylog-plugin-mongodb-profiler;
      description = "Graylog input plugin that reads MongoDB profiler data";
    };
  };
  netflow = glPlugin rec {
    name = "graylog-netflow-${version}";
    pluginName = "graylog-plugin-netflow";
    version = "0.1.1";
    src = fetchurl {
      url = "https://github.com/Graylog2/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "1pdv12f9dca1rxf62ds51n79cjhkkyj0gjny8kj1cq64vlayc9x9";
    };
    meta = {
      homepage = https://github.com/Graylog2/graylog-plugin-netflow;
      description = "Graylog NetFlow plugin";
    };
  };
  redis = glPlugin rec {
    name = "graylog-redis-${version}";
    pluginName = "graylog-plugin-redis";
    version = "0.1.0";
    src = fetchurl {
      url = "https://github.com/Graylog2/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "0hwz83m9gwx0fdapc63v3lr1q6acbphssqwp4qqzz78wg2w79xgi";
    };
    meta = {
      homepage = https://github.com/Graylog2/graylog-plugin-redis;
      description = "Redis plugin for Graylog";
    };
  };
  spaceweather = glPlugin rec {
    name = "graylog-spaceweather-${version}";
    pluginName = "graylog-plugin-spaceweather";
    version = "1.0";
    src = fetchurl {
      url = "https://github.com/Graylog2/${pluginName}/releases/download/${version}/spaceweather-input.jar";
      sha256 = "1mwqy3fhyy4zdwyrzvbr565xwf96xs9d3l70l0khmrm848xf8wz4";
    };
    meta = {
      homepage = https://github.com/Graylog2/graylog-plugin-spaceweather;
      description = "Correlate proton density to the response time of your app and the ion temperature to your exception rate.";
    };
  };
  threatintel = glPlugin rec {
    name = "graylog-threatintel-${version}";
    pluginName = "graylog-plugin-threatintel";
    version = "0.10.0";
    src = fetchurl {
      url = "https://github.com/Graylog2/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "0clg0vy8aipw122rfqww1lnjriazlnnh77pqiy5vnmv6ycjw0y4i";
    };
    meta = {
      homepage = https://github.com/Graylog2/graylog-plugin-threatintel;
      description = "Graylog Processing Pipeline functions to enrich log messages with IoC information from threat intelligence databases";
    };
  };
  twitter = glPlugin rec {
    name = "graylog-twitter-${version}";
    pluginName = "graylog-plugin-twitter";
    version = "2.0.0";
    src = fetchurl {
      url = "https://github.com/Graylog2/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "1pi34swy9nzq35a823zzvqrjhb6wsg302z31vk2y656sw6ljjxyh";
    };
    meta = {
      homepage = https://github.com/Graylog2/graylog-plugin-twitter;
      description = "Graylog input plugin that reads Twitter messages based on keywords in realtime";
    };
  };
}
