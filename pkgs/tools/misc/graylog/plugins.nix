{ pkgs,  stdenv, fetchurl, unzip, graylog }:

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
      dontUnpack = true;
      buildInputs = [ unzip ];
      meta = a.meta // {
        platforms = graylog.meta.platforms;
        maintainers = (a.meta.maintainers or []) ++ [ maintainers.fadenb ];
      };
    });
in {
  aggregates = glPlugin rec {
    name = "graylog-aggregates-${version}";
    pluginName = "graylog-plugin-aggregates";
    version = "2.4.0";
    src = fetchurl {
      url = "https://github.com/cvtienhoven/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "1c48almnjr0b6nvzagnb9yddqbcjs7yhrd5yc5fx9q7w3vxi50zp";
    };
    meta = {
      homepage = "https://github.com/cvtienhoven/graylog-plugin-aggregates";
      description = "SSO support for Graylog through trusted HTTP headers set by load balancers or authentication proxies";
    };
  };
  auth_sso = glPlugin rec {
    name = "graylog-auth-sso-${version}";
    pluginName = "graylog-plugin-auth-sso";
    version = "3.3.0";
    src = fetchurl {
      url = "https://github.com/Graylog2/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "1g47hlld8vzicd47b5i9n2816rbrhv18vjq8gp765c7mdg4a2jn8";
    };
    meta = {
      homepage = "https://github.com/Graylog2/graylog-plugin-auth-sso";
      description = "SSO support for Graylog through trusted HTTP headers set by load balancers or authentication proxies";
    };
  };
  dnsresolver = glPlugin rec {
    name = "graylog-dnsresolver-${version}";
    pluginName = "graylog-plugin-dnsresolver";
    version = "1.2.0";
    src = fetchurl {
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "0djlyd4w4mrrqfbrs20j1xw0fygqsb81snz437v9bf80avmcyzg1";
    };
    meta = {
      homepage = "https://github.com/graylog-labs/graylog-plugin-dnsresolver";
      description = "Message filter plugin can be used to do DNS lookups for the source field in Graylog messages";
    };
  };
  enterprise-integrations = glPlugin rec {
    name = "graylog-enterprise-integrations-${version}";
    pluginName = "graylog-plugin-enterprise-integrations";
    version = "3.3.3";
    src = fetchurl {
      url = "https://downloads.graylog.org/releases/graylog-enterprise-integrations/graylog-enterprise-integrations-plugins-${version}.tgz";
      sha256 = "14b8whgvx8lzil09gjjxhps5syw3slwbh3gswrgc9kh1sqmdhl85";
    };
    installPhase = ''
      mkdir -p $out/bin
      tar --strip-components=2 -xf $src
      cp ${pluginName}-${version}.jar $out/bin/${pluginName}-${version}.jar
    '';
    meta = {
      homepage = "https://docs.graylog.org/en/3.3/pages/integrations.html#enterprise";
      description = "Integrations are tools that help Graylog work with external systems (unfree enterprise integrations)";
      license = stdenv.lib.licenses.unfree;
    };
  };
  filter-messagesize = glPlugin rec {
    name = "graylog-filter-messagesize-${version}";
    pluginName = "graylog-plugin-filter-messagesize";
    version = "0.0.2";
    src = fetchurl {
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "1vx62yikd6d3lbwsfiyf9j6kx8drvn4xhffwv27fw5jzhfqr61ji";
    };
    meta = {
      homepage = "https://github.com/graylog-labs/graylog-plugin-filter-messagesize";
      description = "Prints out all messages that have an estimated size crossing a configured threshold during processing";
    };
  };
  integrations = glPlugin rec {
    name = "graylog-integrations-${version}";
    pluginName = "graylog-plugin-integrations";
    version = "3.3.3";
    src = fetchurl {
      url = "https://downloads.graylog.org/releases/graylog-integrations/graylog-integrations-plugins-${version}.tgz";
      sha256 = "1zf97q8xm81z6q2s7c3nwvpl1m6pc6w7zjm4hmd7ds1br6pg4bdh";
    };
    installPhase = ''
      mkdir -p $out/bin
      tar --strip-components=2 -xf $src
      cp ${pluginName}-${version}.jar $out/bin/${pluginName}-${version}.jar
    '';
    meta = {
      homepage = https://github.com/Graylog2/graylog-plugin-integrations;
      description = "A collection of open source Graylog integrations that will be released together";
    };
  };
  internal-logs = glPlugin rec {
    name = "graylog-internal-logs-${version}";
    pluginName = "graylog-plugin-internal-logs";
    version = "2.4.0";
    src = fetchurl {
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "1jyy0wkjapv3xv5q957xxv2pcnd4n1yivkvkvg6cx7kv1ip75xwc";
    };
    meta = {
      homepage = "https://github.com/graylog-labs/graylog-plugin-internal-logs";
      description = "Graylog plugin to record internal logs of Graylog efficiently instead of sending them over the network";
    };
  };
  ipanonymizer = glPlugin rec {
    name = "graylog-ipanonymizer-${version}";
    pluginName = "graylog-plugin-ipanonymizer";
    version = "1.1.2";
    src = fetchurl {
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "0hd66751hp97ddkn29s1cmjmc2h1nrp431bq7d2wq16iyxxlygri";
    };
    meta = {
      homepage = "https://github.com/graylog-labs/graylog-plugin-ipanonymizer";
      description = "A graylog-server plugin that replaces the last octet of IP addresses in messages with xxx";
    };
  };
  jabber = glPlugin rec {
    name = "graylog-jabber-${version}";
    pluginName = "graylog-plugin-jabber";
    version = "2.4.0";
    src = fetchurl {
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "0zy27q8y0bv7i5nypsfxad4yiw121sbwzd194jsz2w08jhk3skl5";
    };
    meta = {
      homepage = "https://github.com/graylog-labs/graylog-plugin-jabber";
      description = "Jabber Alarmcallback Plugin for Graylog";
    };
  };
  metrics = glPlugin rec {
    name = "graylog-metrics-${version}";
    pluginName = "graylog-plugin-metrics";
    version = "1.3.0";
    src = fetchurl {
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "1v1yzmqp43kxigh3fymdwki7pn21sk2ym3kk4nn4qv4zzkhz59vp";
    };
    meta = {
      homepage = "https://github.com/graylog-labs/graylog-plugin-metrics";
      description = "An output plugin for integrating Graphite, Ganglia and StatsD with Graylog";
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
      homepage = "https://github.com/graylog-labs/graylog-plugin-mongodb-profiler";
      description = "Graylog input plugin that reads MongoDB profiler data";
    };
  };
  pagerduty = glPlugin rec {
    name = "graylog-pagerduty-${version}";
    pluginName = "graylog-plugin-pagerduty";
    version = "2.0.0";
    src = fetchurl {
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "0xhcwfwn7c77giwjilv7k7aijnj9azrjbjgd0r3p6wdrw970f27r";
    };
    meta = {
      homepage = "https://github.com/graylog-labs/graylog-plugin-pagerduty";
      description = "An alarm callback plugin for integrating PagerDuty into Graylog";
    };
  };
  redis = glPlugin rec {
    name = "graylog-redis-${version}";
    pluginName = "graylog-plugin-redis";
    version = "0.1.1";
    src = fetchurl {
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "0dfgh6w293ssagas5y0ixwn0vf54i5iv61r5p2q0rbv2da6xvhbw";
    };
    meta = {
      homepage = "https://github.com/graylog-labs/graylog-plugin-redis";
      description = "Redis plugin for Graylog";
    };
  };
  slack = glPlugin rec {
    name = "graylog-slack-${version}";
    pluginName = "graylog-plugin-slack";
    version = "3.1.0";
    src = fetchurl {
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "067p8g94b007gypwyyi8vb6qhwdanpk8ah57abik54vv14jxg94k";
    };
    meta = {
      homepage = "https://github.com/graylog-labs/graylog-plugin-slack";
      description = "Can notify Slack or Mattermost channels about triggered alerts in Graylog (Alarm Callback)";
    };
  };
  snmp = glPlugin rec {
    name = "graylog-snmp-${version}";
    pluginName = "graylog-plugin-snmp";
    version = "0.3.0";
    src = fetchurl {
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "1hkaklwzcsvqq45b98chwqxqdgnnbj4dg68agsll13yq4zx37qpp";
    };
    meta = {
      homepage = https://github.com/graylog-labs/graylog-plugin-snmp;
      description = "Graylog plugin to receive SNMP traps";
    };
  };
  spaceweather = glPlugin rec {
    name = "graylog-spaceweather-${version}";
    pluginName = "graylog-plugin-spaceweather";
    version = "1.0";
    src = fetchurl {
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/spaceweather-input.jar";
      sha256 = "1mwqy3fhyy4zdwyrzvbr565xwf96xs9d3l70l0khmrm848xf8wz4";
    };
    meta = {
      homepage = "https://github.com/graylog-labs/graylog-plugin-spaceweather";
      description = "Correlate proton density to the response time of your app and the ion temperature to your exception rate.";
    };
  };
  twiliosms = glPlugin rec {
    name = "graylog-twiliosms-${version}";
    pluginName = "graylog-plugin-twiliosms";
    version = "1.0.0";
    src = fetchurl {
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "0kwfv1zfj0fmxh9i6413bcsaxrn1vdwrzb6dphvg3dx27wxn1j1a";
    };
    meta = {
      homepage = "https://github.com/graylog-labs/graylog-plugin-twiliosms";
      description = "An alarm callback plugin for integrating the Twilio SMS API into Graylog";
    };
  };
  twitter = glPlugin rec {
    name = "graylog-twitter-${version}";
    pluginName = "graylog-plugin-twitter";
    version = "2.0.0";
    src = fetchurl {
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "1pi34swy9nzq35a823zzvqrjhb6wsg302z31vk2y656sw6ljjxyh";
    };
    meta = {
      homepage = "https://github.com/graylog-labs/graylog-plugin-twitter";
      description = "Graylog input plugin that reads Twitter messages based on keywords in realtime";
    };
  };
}
