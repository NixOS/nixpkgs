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
      unpackPhase = "true";
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
    version = "2.0.0";
    src = fetchurl {
      url = "https://github.com/cvtienhoven/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "0crgb49msjkvfpksbfhq2hlkc904j184wm1wp6q0x6lzhn07hm8y";
    };
    meta = {
      homepage = https://github.com/cvtienhoven/graylog-plugin-aggregates;
      description = "SSO support for Graylog through trusted HTTP headers set by load balancers or authentication proxies";
    };
  };
  auth_sso = glPlugin rec {
    name = "graylog-auth-sso-${version}";
    pluginName = "graylog-plugin-auth-sso";
    version = "2.3.0";
    src = fetchurl {
      url = "https://github.com/Graylog2/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "110ag10y0xyf3za6663vf68r5rwdi92315a37vysqvj00y7yak0l";
    };
    meta = {
      homepage = https://github.com/Graylog2/graylog-plugin-auth-sso;
      description = "SSO support for Graylog through trusted HTTP headers set by load balancers or authentication proxies";
    };
  };
  dnsresolver = glPlugin rec {
    name = "graylog-dnsresolver-${version}";
    pluginName = "graylog-plugin-dnsresolver";
    version = "1.1.2";
    src = fetchurl {
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "01s7wm6bwcpmdrl35gjp6rrqxixs2s9km2bdgzhv8pn25j5qnw28";
    };
    meta = {
      homepage = https://github.com/graylog-labs/graylog-plugin-dnsresolver;
      description = "Message filter plugin can be used to do DNS lookups for the source field in Graylog messages";
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
      homepage = https://github.com/graylog-labs/graylog-plugin-filter-messagesize;
      description = "Prints out all messages that have an estimated size crossing a configured threshold during processing";
    };
  };
  internal-logs = glPlugin rec {
    name = "graylog-internal-logs-${version}";
    pluginName = "graylog-plugin-internal-logs";
    version = "2.3.0";
    src = fetchurl {
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "05r4m2gf1hj1b889rmpb6b5a6q2xd0qkl1rpj107yd219j2grzf4";
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
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "0hd66751hp97ddkn29s1cmjmc2h1nrp431bq7d2wq16iyxxlygri";
    };
    meta = {
      homepage = https://github.com/graylog-labs/graylog-plugin-ipanonymizer;
      description = "A graylog-server plugin that replaces the last octet of IP addresses in messages with xxx";
    };
  };
  jabber = glPlugin rec {
    name = "graylog-jabber-${version}";
    pluginName = "graylog-plugin-jabber";
    version = "2.0.0";
    src = fetchurl {
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "1bqj5g9zjnw08bva7379c2ar3nhmyiilj7kjxd16qvfdn2674r5h";
    };
    meta = {
      homepage = https://github.com/graylog-labs/graylog-plugin-jabber;
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
      homepage = https://github.com/graylog-labs/graylog-plugin-metrics;
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
      homepage = https://github.com/graylog-labs/graylog-plugin-mongodb-profiler;
      description = "Graylog input plugin that reads MongoDB profiler data";
    };
  };
  pagerduty = glPlugin rec {
    name = "graylog-pagerduty-${version}";
    pluginName = "graylog-plugin-pagerduty";
    version = "1.3.0";
    src = fetchurl {
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "1g63c6rm5pkz7f0d73wb2lmk4zm430jqnhihbyq112cm4i7ymglh";
    };
    meta = {
      homepage = https://github.com/graylog-labs/graylog-plugin-pagerduty;
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
      homepage = https://github.com/graylog-labs/graylog-plugin-redis;
      description = "Redis plugin for Graylog";
    };
  };
  slack = glPlugin rec {
    name = "graylog-slack-${version}";
    pluginName = "graylog-plugin-slack";
    version = "2.4.0";
    src = fetchurl {
      url = "https://github.com/graylog-labs/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "0v8ilfhs8bnx87pjxg1i3p2vxw61rwpg4k3zhga7slavx70y986p";
    };
    meta = {
      homepage = https://github.com/graylog-labs/graylog-plugin-slack;
      description = "Can notify Slack or Mattermost channels about triggered alerts in Graylog (Alarm Callback)";
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
      homepage = https://github.com/graylog-labs/graylog-plugin-spaceweather;
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
      homepage = https://github.com/graylog-labs/graylog-plugin-twiliosms;
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
      homepage = https://github.com/graylog-labs/graylog-plugin-twitter;
      description = "Graylog input plugin that reads Twitter messages based on keywords in realtime";
    };
  };
}
