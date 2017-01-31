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
  graylog_anonymous_usage_statistics = glPlugin rec {
    name = "graylog-anonymous-usage-statistics-${version}";
    pluginName = "graylog-plugin-anonymous-usage-statistics";
    version = "2.2.0-rc.1";
    src = fetchurl {
      url = "https://github.com/Graylog2/${pluginName}/releases/download/${version}/graylog-plugin-anonymous-usage-statistics-${version}.jar";
      sha256 = "1qsxx6hrbx12bbpq4dqd7zhqhlmgv0i5q7ljjmdada4hv5fg6346";
    };
    meta = {
      homepage = "https://github.com/Graylog2/graylog-plugin-anonymous-usage-statistics";
      description = "Plugin to collect anonymous usage statistics of Graylog";
    };
  };
  graylog_auth_sso = glPlugin rec {
    name = "graylog-auth-sso-${version}";
    pluginName = "graylog-plugin-auth-sso";
    version = "1.0.5";
    src = fetchurl {
      url = "https://github.com/Graylog2/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "14m8nilimdh6rp8bssks1hhqs0729q6wga2brbqi3dgmmy4gcwfn";
    };
    meta = {
      homepage = "https://github.com/Graylog2/graylog-plugin-auth-sso";
      description = "SSO support for Graylog through trusted HTTP headers set by load balancers or authentication proxies";
    };
  };
  graylog_beats = glPlugin rec {
    name = "graylog-beats-${version}";
    pluginName = "graylog-plugin-beats";
    version = "2.2.0-rc.1";
    src = fetchurl {
      url = "https://github.com/Graylog2/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "13v8f2sbp1rd9f9r191z6x83slpvzm6lvhkbzm8367xm08jansv3";
    };
    meta = {
      homepage = "https://github.com/Graylog2/graylog-plugin-beats";
      description = "Elastic Beats Input plugin for Graylog";
    };
  };
  graylog_collector = glPlugin rec {
    name = "graylog-collector-${version}";
    pluginName = "graylog-plugin-collector";
    version = "2.2.0-rc.1";
    src = fetchurl {
      url = "https://github.com/Graylog2/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "06f27w0bzpqd842w6ydlpdq8mplwsnyhw0v6nvj90fx54rpxfadv";
    };
    meta = {
      homepage = "https://github.com/Graylog2/graylog-plugin-collector";
      description = "Collector plugin for Graylog";
    };
  };
  graylog_ipanonymizer = glPlugin rec {
    name = "graylog-ipanonymizer-${version}";
    pluginName = "graylog-plugin-ipanonymizer";
    version = "1.1.2";
    src = fetchurl {
      url = "https://github.com/Graylog2/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "0hd66751hp97ddkn29s1cmjmc2h1nrp431bq7d2wq16iyxxlygri";
    };
    meta = {
      homepage = "https://github.com/Graylog2/graylog-plugin-ipanonymizer";
      description = "A graylog-server plugin that replaces the last octet of IP addresses in messages with xxx";
    };
  };
  graylog_netflow = glPlugin rec {
    name = "graylog-netflow-${version}";
    pluginName = "graylog-plugin-netflow";
    version = "0.1.1";
    src = fetchurl {
      url = "https://github.com/Graylog2/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "1pdv12f9dca1rxf62ds51n79cjhkkyj0gjny8kj1cq64vlayc9x9";
    };
    meta = {
      homepage = "https://github.com/Graylog2/graylog-plugin-netflow";
      description = "Graylog NetFlow plugin";
    };
  };
  graylog_spaceweather = glPlugin rec {
    name = "graylog-spaceweather-${version}";
    pluginName = "graylog-plugin-spaceweather";
    version = "1.0";
    src = fetchurl {
      url = "https://github.com/Graylog2/${pluginName}/releases/download/${version}/spaceweather-input.jar";
      sha256 = "1mwqy3fhyy4zdwyrzvbr565xwf96xs9d3l70l0khmrm848xf8wz4";
    };
    meta = {
      homepage = "https://github.com/Graylog2/graylog-plugin-spaceweather";
      description = "Correlate proton density to the response time of your app and the ion temperature to your exception rate.";
    };
  };
  graylog_threatintel = glPlugin rec {
    name = "graylog-threatintel-${version}";
    pluginName = "graylog-plugin-threatintel";
    version = "0.9.0";
    src = fetchurl {
      url = "https://github.com/Graylog2/${pluginName}/releases/download/${version}/${pluginName}-${version}.jar";
      sha256 = "1sqa4676rn142s7d8ipw7ww52ba49js4lp63jszl7ss5a3qf3v3v";
    };
    meta = {
      homepage = "https://github.com/Graylog2/graylog-plugin-threatintel";
      description = "Graylog Processing Pipeline functions to enrich log messages with IoC information from threat intelligence databases";
    };
  };
}
