{
  lib,
  beamPackages,
  overrides ? (x: y: { }),
}:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages =
    with beamPackages;
    with self;
    {
      accept = buildRebar3 rec {
        name = "accept";
        version = "0.3.5";

        src = fetchHex {
          pkg = "accept";
          version = "${version}";
          hash = "sha256-EbGMIgvMLqtjtUcMA47xDrZ4O8sfzbEapBN976WsG7g=";
        };

        beamDeps = [ ];
      };

      argon2_elixir = buildMix rec {
        name = "argon2_elixir";
        version = "4.0.0";

        src = fetchHex {
          pkg = "argon2_elixir";
          version = "${version}";
          hash = "sha256-+donzwYMnqYbG9R4N6KNfkio9voTp0XiUlVsFPkTLH8=";
        };

        beamDeps = [
          comeonin
          elixir_make
        ];
      };

      bandit = buildMix rec {
        name = "bandit";
        version = "1.5.5";

        src = fetchHex {
          pkg = "bandit";
          version = "${version}";
          hash = "sha256-8hV5op6kvAhEA0OytfFvfN3y/qVyXTG3LPlz7HKQeeE=";
        };

        beamDeps = [
          hpax
          plug
          telemetry
          thousand_island
          websock
        ];
      };

      base62 = buildMix rec {
        name = "base62";
        version = "1.2.2";

        src = fetchHex {
          pkg = "base62";
          version = "${version}";
          hash = "sha256-1BM2vajqpb4Zfx5FkkAFE+5gUY5bn03POPS02ubzd7s=";
        };

        beamDeps = [ custom_base ];
      };

      bbcode_pleroma = buildMix rec {
        name = "bbcode_pleroma";
        version = "0.2.0";

        src = fetchHex {
          pkg = "bbcode_pleroma";
          version = "${version}";
          hash = "sha256-GYUQdEGaX+2070nh8Bsw31BLtdu21q38E1I4Bjvr0cM=";
        };

        beamDeps = [ nimble_parsec ];
      };

      bcrypt_elixir = buildMix rec {
        name = "bcrypt_elixir";
        version = "2.3.1";

        src = fetchHex {
          pkg = "bcrypt_elixir";
          version = "${version}";
          hash = "sha256-QhgtX0Z2Te8Vv5r4Nznjv0rSJmGxw0/D6IVY787Qcnk=";
        };

        beamDeps = [
          comeonin
          elixir_make
        ];
      };

      benchee = buildMix rec {
        name = "benchee";
        version = "1.3.0";

        src = fetchHex {
          pkg = "benchee";
          version = "${version}";
          hash = "sha256-NPQpQGjBGyvS6/LFmqycfaJv+gBor980GfGxduFsX4E=";
        };

        beamDeps = [
          deep_merge
          statistex
        ];
      };

      blurhash = buildMix rec {
        name = "blurhash";
        version = "0.1.0";

        src = fetchHex {
          pkg = "rinpatch_blurhash";
          version = "${version}";
          hash = "sha256-GZEaXcuwrLlxAWmnL3ArzmywSIIrEt5WbM2CssxCuQc=";
        };

        beamDeps = [ mogrify ];
      };

      bunt = buildMix rec {
        name = "bunt";
        version = "1.0.0";

        src = fetchHex {
          pkg = "bunt";
          version = "${version}";
          hash = "sha256-3F+Gqgil9vprgJbwc1xOdtVK5cn6LBQ+Wh/Hwc2btrU=";
        };

        beamDeps = [ ];
      };

      cachex = buildMix rec {
        name = "cachex";
        version = "3.6.0";

        src = fetchHex {
          pkg = "cachex";
          version = "${version}";
          hash = "sha256-6/JONziDvI4MjYlKY7vhAq4T2Rj3kBIfXP5uSFzI4uI=";
        };

        beamDeps = [
          eternal
          jumper
          sleeplocks
          unsafe
        ];
      };

      calendar = buildMix rec {
        name = "calendar";
        version = "1.0.0";

        src = fetchHex {
          pkg = "calendar";
          version = "${version}";
          hash = "sha256-mQ6VgZIMgpEqXuUOYv9e+W2msVlJou5HNPk1/e8PCm8=";
        };

        beamDeps = [ tzdata ];
      };

      castore = buildMix rec {
        name = "castore";
        version = "1.0.8";

        src = fetchHex {
          pkg = "castore";
          version = "${version}";
          hash = "sha256-Cytm0u50LLHZy4yL47Q8OnDuhlHze3WouYLgNnUpg/E=";
        };

        beamDeps = [ ];
      };

      cc_precompiler = buildMix rec {
        name = "cc_precompiler";
        version = "0.1.9";

        src = fetchHex {
          pkg = "cc_precompiler";
          version = "${version}";
          hash = "sha256-ncqz0PMDhiHxYB8TU556numYQ4YuZq1ignsMQrL1ilQ=";
        };

        beamDeps = [ elixir_make ];
      };

      certifi = buildRebar3 rec {
        name = "certifi";
        version = "2.12.0";

        src = fetchHex {
          pkg = "certifi";
          version = "${version}";
          hash = "sha256-7mjYXfIuVUBAzbS+EA8zhzrGBROHuvao9s6CJyNA/xw=";
        };

        beamDeps = [ ];
      };

      combine = buildMix rec {
        name = "combine";
        version = "0.10.0";

        src = fetchHex {
          pkg = "combine";
          version = "${version}";
          hash = "sha256-Gx28F5AHMHZYDQ0dZOQuriNmWD567NRV0SFbDRbyRRs=";
        };

        beamDeps = [ ];
      };

      comeonin = buildMix rec {
        name = "comeonin";
        version = "5.4.0";

        src = fetchHex {
          pkg = "comeonin";
          version = "${version}";
          hash = "sha256-eWOTqeUNAZmdVre4QgqwSBp1ONDK+AkZ2kk7Sm5R+vE=";
        };

        beamDeps = [ ];
      };

      concurrent_limiter = buildMix rec {
        name = "concurrent_limiter";
        version = "0.1.1";

        src = fetchHex {
          pkg = "concurrent_limiter";
          version = "${version}";
          hash = "sha256-U5aP8jjA+7TX7Xbdsa8L5vOy93kJ9nluJJ5zfFBaFus=";
        };

        beamDeps = [ telemetry ];
      };

      connection = buildMix rec {
        name = "connection";
        version = "1.1.0";

        src = fetchHex {
          pkg = "connection";
          version = "${version}";
          hash = "sha256-ciwesKQY++kbp71ZpH4oAIoYnUfjfg57uFWFoBayhpw=";
        };

        beamDeps = [ ];
      };

      cors_plug = buildMix rec {
        name = "cors_plug";
        version = "2.0.3";

        src = fetchHex {
          pkg = "cors_plug";
          version = "${version}";
          hash = "sha256-7krhQY5s4Rf8QsK6Pmy9yk6V7NL+WaBexohMoW1Gmuo=";
        };

        beamDeps = [ plug ];
      };

      covertool = buildRebar3 rec {
        name = "covertool";
        version = "2.0.6";

        src = fetchHex {
          pkg = "covertool";
          version = "${version}";
          hash = "sha256-XbP82CGA2OpK2FfU0ashqNMbWu4NYNL2wPniWkEdHiE=";
        };

        beamDeps = [ ];
      };

      cowboy = buildErlangMk rec {
        name = "cowboy";
        version = "2.12.0";

        src = fetchHex {
          pkg = "cowboy";
          version = "${version}";
          hash = "sha256-inq+bRgzcs6yHKonCb7JKKsrcuGKORGqF3Fjm++CZR4=";
        };

        beamDeps = [
          cowlib
          ranch
        ];
      };

      cowboy_telemetry = buildRebar3 rec {
        name = "cowboy_telemetry";
        version = "0.4.0";

        src = fetchHex {
          pkg = "cowboy_telemetry";
          version = "${version}";
          hash = "sha256-fZi6we5FZdMbYtWfiCPf2DVqFp5/y7g4MbilOXQEyd4=";
        };

        beamDeps = [
          cowboy
          telemetry
        ];
      };

      cowlib = buildRebar3 rec {
        name = "cowlib";
        version = "2.13.0";

        src = fetchHex {
          pkg = "cowlib";
          version = "${version}";
          hash = "sha256-4eEoTcP8Awpksa0Ng4KufpnaRsMka4FTGKS4SIc4AKQ=";
        };

        beamDeps = [ ];
      };

      credo = buildMix rec {
        name = "credo";
        version = "1.7.7";

        src = fetchHex {
          pkg = "credo";
          version = "${version}";
          hash = "sha256-i8h0lsmqrNw/kPAbewWCRntptL0kQf6KrjEJ2EPMLy4=";
        };

        beamDeps = [
          bunt
          file_system
          jason
        ];
      };

      crontab = buildMix rec {
        name = "crontab";
        version = "1.1.8";

        src = fetchHex {
          pkg = "crontab";
          version = "${version}";
          hash = "sha256-SOUTKZzSixLHcmbA7VschENo5cGCNySZSuhINPQ9a74=";
        };

        beamDeps = [ ecto ];
      };

      custom_base = buildMix rec {
        name = "custom_base";
        version = "0.2.1";

        src = fetchHex {
          pkg = "custom_base";
          version = "${version}";
          hash = "sha256-jfAZ+sxeyWA+lPcnDxrHPd8zn1at52pyHqpXwUk7pGM=";
        };

        beamDeps = [ ];
      };

      db_connection = buildMix rec {
        name = "db_connection";
        version = "2.7.0";

        src = fetchHex {
          pkg = "db_connection";
          version = "${version}";
          hash = "sha256-3PCPMbJwH4V9/Hh/uteCI9YaMiBPIX8V6IHdk+S90/8=";
        };

        beamDeps = [ telemetry ];
      };

      decimal = buildMix rec {
        name = "decimal";
        version = "2.1.1";

        src = fetchHex {
          pkg = "decimal";
          version = "${version}";
          hash = "sha256-U8/l9JftDndxrhpHVXVgPXdCUJm6X675OUkys1Ag/8w=";
        };

        beamDeps = [ ];
      };

      deep_merge = buildMix rec {
        name = "deep_merge";
        version = "1.0.0";

        src = fetchHex {
          pkg = "deep_merge";
          version = "${version}";
          hash = "sha256-znCOXwlLnNTo8r5PANL0JQxAlb6T+M1tAYx1OJSIVDA=";
        };

        beamDeps = [ ];
      };

      dialyxir = buildMix rec {
        name = "dialyxir";
        version = "1.4.3";

        src = fetchHex {
          pkg = "dialyxir";
          version = "${version}";
          hash = "sha256-vyz7dc1cUAa+wwFBsTFmMpnGYahk7H+7xy36VXSHqYY=";
        };

        beamDeps = [ erlex ];
      };

      earmark = buildMix rec {
        name = "earmark";
        version = "1.4.46";

        src = fetchHex {
          pkg = "earmark";
          version = "${version}";
          hash = "sha256-eY2G2z15lk51ndwMB31eslSWjtQmOZ+/WmLeK1/4kQo=";
        };

        beamDeps = [ ];
      };

      earmark_parser = buildMix rec {
        name = "earmark_parser";
        version = "1.4.39";

        src = fetchHex {
          pkg = "earmark_parser";
          version = "${version}";
          hash = "sha256-BlU6iNHxhG2p7wZrh7V8b2BVUs++QNIL2NWcxr3kGUQ=";
        };

        beamDeps = [ ];
      };

      ecto = buildMix rec {
        name = "ecto";
        version = "3.11.2";

        src = fetchHex {
          pkg = "ecto";
          version = "${version}";
          hash = "sha256-PDi8osb42AI/IUUybMioAQDD/+TcvZhC/4Z/f8YVbGU=";
        };

        beamDeps = [
          decimal
          jason
          telemetry
        ];
      };

      ecto_enum = buildMix rec {
        name = "ecto_enum";
        version = "1.4.0";

        src = fetchHex {
          pkg = "ecto_enum";
          version = "${version}";
          hash = "sha256-j7VcCHGBwrFe7kBlGdwiV4+mDdgsCIvjdtABAXJ2TuQ=";
        };

        beamDeps = [
          ecto
          ecto_sql
          postgrex
        ];
      };

      ecto_psql_extras = buildMix rec {
        name = "ecto_psql_extras";
        version = "0.7.15";

        src = fetchHex {
          pkg = "ecto_psql_extras";
          version = "${version}";
          hash = "sha256-thJ/Olxvw9hIleR2jMfBmfIrSLZ9bJmxP79KN05z8Dk=";
        };

        beamDeps = [
          ecto_sql
          postgrex
          table_rex
        ];
      };

      ecto_sql = buildMix rec {
        name = "ecto_sql";
        version = "3.11.3";

        src = fetchHex {
          pkg = "ecto_sql";
          version = "${version}";
          hash = "sha256-5fNuPXNrmcf+4+YxMzuDlK3kuv6dltNWafyi2Bwr6Sg=";
        };

        beamDeps = [
          db_connection
          ecto
          postgrex
          telemetry
        ];
      };

      eimp = buildRebar3 rec {
        name = "eimp";
        version = "1.0.14";

        src = fetchHex {
          pkg = "eimp";
          version = "${version}";
          hash = "sha256-UBEz8xEgebktniLai4i/Tw4T1NZ66cFcQsML0lzrg7Y=";
        };

        beamDeps = [ p1_utils ];
      };

      elixir_make = buildMix rec {
        name = "elixir_make";
        version = "0.7.8";

        src = fetchHex {
          pkg = "elixir_make";
          version = "${version}";
          hash = "sha256-enGUW5E9N+qJsGlm4TQshc/lSbFebW0IHoCBxJMGLAc=";
        };

        beamDeps = [
          castore
          certifi
        ];
      };

      erlex = buildMix rec {
        name = "erlex";
        version = "0.2.6";

        src = fetchHex {
          pkg = "erlex";
          version = "${version}";
          hash = "sha256-LtLiVxH+tE1SsX0ngOq/mYRS9u/aEEh3o4gcL4wMDHU=";
        };

        beamDeps = [ ];
      };

      esbuild = buildMix rec {
        name = "esbuild";
        version = "0.5.0";

        src = fetchHex {
          pkg = "esbuild";
          version = "${version}";
          hash = "sha256-8YOgszLZY8TPr1hUd2lepZ7vmm8iBP3Q76AOCZaU/+U=";
        };

        beamDeps = [ castore ];
      };

      eternal = buildMix rec {
        name = "eternal";
        version = "1.2.2";

        src = fetchHex {
          pkg = "eternal";
          version = "${version}";
          hash = "sha256-LJ/jK5w3JnA7peHUOh0lWk8/LY+Pm8GfCUx8saep54I=";
        };

        beamDeps = [ ];
      };

      ex_aws = buildMix rec {
        name = "ex_aws";
        version = "2.1.9";

        src = fetchHex {
          pkg = "ex_aws";
          version = "${version}";
          hash = "sha256-Pmx3ZwPJB2AB++H3wElTXwQssq+g0svTtHy8TpKsDRA=";
        };

        beamDeps = [
          hackney
          jason
          sweet_xml
        ];
      };

      ex_aws_s3 = buildMix rec {
        name = "ex_aws_s3";
        version = "2.5.3";

        src = fetchHex {
          pkg = "ex_aws_s3";
          version = "${version}";
          hash = "sha256-TwndNyzDhlUOSEgIxaxQJ3ZsjQzYJxzMV4uC7m7087g=";
        };

        beamDeps = [
          ex_aws
          sweet_xml
        ];
      };

      ex_const = buildMix rec {
        name = "ex_const";
        version = "0.2.4";

        src = fetchHex {
          pkg = "ex_const";
          version = "${version}";
          hash = "sha256-lv00ZhDMmSuPiW7Sapi+gqxO+wZaBXjzNKMtYKO6l2c=";
        };

        beamDeps = [ ];
      };

      ex_doc = buildMix rec {
        name = "ex_doc";
        version = "0.31.1";

        src = fetchHex {
          pkg = "ex_doc";
          version = "${version}";
          hash = "sha256-MXjDpAfFV9g0NHnh/xF6lv0xuv5SoDkHlZP7BSTvYbA=";
        };

        beamDeps = [
          earmark_parser
          makeup_elixir
          makeup_erlang
        ];
      };

      ex_machina = buildMix rec {
        name = "ex_machina";
        version = "2.7.0";

        src = fetchHex {
          pkg = "ex_machina";
          version = "${version}";
          hash = "sha256-QZqno5veEYlMh6YVxOyqUtjxB7vdgdgQRlGG94MkW/g=";
        };

        beamDeps = [
          ecto
          ecto_sql
        ];
      };

      ex_syslogger = buildMix rec {
        name = "ex_syslogger";
        version = "1.5.2";

        src = fetchHex {
          pkg = "ex_syslogger";
          version = "${version}";
          hash = "sha256-q5+rQTbbxiZR7G8W+khC8QzwKrRDP6PQl2wBvpk5g5k=";
        };

        beamDeps = [
          poison
          syslog
        ];
      };

      exile = buildMix rec {
        name = "exile";
        version = "0.10.0";

        src = fetchHex {
          pkg = "exile";
          version = "${version}";
          hash = "sha256-xi7o/uVltaxKiY0NzVjSsE+17sFlWvHdzJ61gsZzLDM=";
        };

        beamDeps = [ elixir_make ];
      };

      expo = buildMix rec {
        name = "expo";
        version = "0.5.1";

        src = fetchHex {
          pkg = "expo";
          version = "${version}";
          hash = "sha256-aKQjOwZYo9Eu4A0n032FaxukhgfnziD9N2lY0Lps6Ss=";
        };

        beamDeps = [ ];
      };

      fast_html = buildMix rec {
        name = "fast_html";
        version = "2.3.0";

        src = fetchHex {
          pkg = "fast_html";
          version = "${version}";
          hash = "sha256-8Y48dmj4LTrgsV9I1I/uslfiiqWrGw2/eBxzEuXaAp0=";
        };

        beamDeps = [
          elixir_make
          nimble_pool
        ];
      };

      fast_sanitize = buildMix rec {
        name = "fast_sanitize";
        version = "0.2.3";

        src = fetchHex {
          pkg = "fast_sanitize";
          version = "${version}";
          hash = "sha256-6K0obRDQOG4V1n0O4SUkXrz7x9cpCwhxK6kBPIxeVuI=";
        };

        beamDeps = [
          fast_html
          plug
        ];
      };

      file_system = buildMix rec {
        name = "file_system";
        version = "0.2.10";

        src = fetchHex {
          pkg = "file_system";
          version = "${version}";
          hash = "sha256-QRle2/tWKlk3Ju2js+ixA6MJtzOtJfPWQrpJaWv3Fdw=";
        };

        beamDeps = [ ];
      };

      finch = buildMix rec {
        name = "finch";
        version = "0.18.0";

        src = fetchHex {
          pkg = "finch";
          version = "${version}";
          hash = "sha256-afUEWwQuUx5T7cJXTxXiXnNbUiw34t23ZuFbl54DqmU=";
        };

        beamDeps = [
          castore
          mime
          mint
          nimble_options
          nimble_pool
          telemetry
        ];
      };

      flake_id = buildMix rec {
        name = "flake_id";
        version = "0.1.0";

        src = fetchHex {
          pkg = "flake_id";
          version = "${version}";
          hash = "sha256-MfyAkP3hrNJnwHw26nNluGBAVfiX06U92WdljGkb2Cc=";
        };

        beamDeps = [
          base62
          ecto
        ];
      };

      floki = buildMix rec {
        name = "floki";
        version = "0.35.2";

        src = fetchHex {
          pkg = "floki";
          version = "${version}";
          hash = "sha256-awUomo6erEdfZE8JwuS6fhkgH9ACuJwowSk+e9Fnc9k=";
        };

        beamDeps = [ ];
      };

      gen_smtp = buildRebar3 rec {
        name = "gen_smtp";
        version = "0.15.0";

        src = fetchHex {
          pkg = "gen_smtp";
          version = "${version}";
          hash = "sha256-Kb0UqIAwmAhJx+0kR7jbbWySeKKLEaRMr+QbeRIFRA8=";
        };

        beamDeps = [ ];
      };

      gettext = buildMix rec {
        name = "gettext";
        version = "0.24.0";

        src = fetchHex {
          pkg = "gettext";
          version = "${version}";
          hash = "sha256-vfdc38vp5GIt0Y4DSyJ9d90X8PEzhTocc7l7PWx3Dos=";
        };

        beamDeps = [ expo ];
      };

      gun = buildRebar3 rec {
        name = "gun";
        version = "2.0.1";

        src = fetchHex {
          pkg = "gun";
          version = "${version}";
          hash = "sha256-oQvI1glrlQIgUCIzT3GcyaCNmtz7/A2+6e8xtWJ0ogs=";
        };

        beamDeps = [ cowlib ];
      };

      hackney = buildRebar3 rec {
        name = "hackney";
        version = "1.18.2";

        src = fetchHex {
          pkg = "hackney";
          version = "${version}";
          hash = "sha256-r5TVyfl4V9slcJCkoQ5UJuy29JGKpcxmZ5hWauFLZf0=";
        };

        beamDeps = [
          certifi
          idna
          metrics
          mimerl
          parse_trans
          ssl_verify_fun
          unicode_util_compat
        ];
      };

      hpax = buildMix rec {
        name = "hpax";
        version = "0.2.0";

        src = fetchHex {
          pkg = "hpax";
          version = "${version}";
          hash = "sha256-vqBlWM2uhb7QdebANpk9Q81U1Ef3bYGQqNsNxYk/ovE=";
        };

        beamDeps = [ ];
      };

      html_entities = buildMix rec {
        name = "html_entities";
        version = "0.5.2";

        src = fetchHex {
          pkg = "html_entities";
          version = "${version}";
          hash = "sha256-xTujkEA0hWFWI7lTHpdpbwdu1BXo2AWLHbqigYH0/cw=";
        };

        beamDeps = [ ];
      };

      http_signatures = buildMix rec {
        name = "http_signatures";
        version = "0.1.2";

        src = fetchHex {
          pkg = "http_signatures";
          version = "${version}";
          hash = "sha256-8IqprBIYKdrhCdYI2DyEuUDvLxg65Q8t0emovGGdi+c=";
        };

        beamDeps = [ ];
      };

      httpoison = buildMix rec {
        name = "httpoison";
        version = "1.8.2";

        src = fetchHex {
          pkg = "httpoison";
          version = "${version}";
          hash = "sha256-K7NQ0mly4wyW4sp0oar4KT1h0HQv8X8B4Cef7xFZmSE=";
        };

        beamDeps = [ hackney ];
      };

      idna = buildRebar3 rec {
        name = "idna";
        version = "6.1.1";

        src = fetchHex {
          pkg = "idna";
          version = "${version}";
          hash = "sha256-kjdut4lEEu0ZrEdeSob3tBPBufu1vRbczVeTQVeUTOo=";
        };

        beamDeps = [ unicode_util_compat ];
      };

      inet_cidr = buildMix rec {
        name = "inet_cidr";
        version = "1.0.8";

        src = fetchHex {
          pkg = "inet_cidr";
          version = "${version}";
          hash = "sha256-1bJtpmYDu1bJM8ZSFMchUvDemm6lNhi1bWMwKmj2qQ4=";
        };

        beamDeps = [ ];
      };

      jason = buildMix rec {
        name = "jason";
        version = "1.4.4";

        src = fetchHex {
          pkg = "jason";
          version = "${version}";
          hash = "sha256-xesMq5HwlFmflNVbxjQJI2qOxpohpngUUp6NX2zJCzs=";
        };

        beamDeps = [ decimal ];
      };

      joken = buildMix rec {
        name = "joken";
        version = "2.6.0";

        src = fetchHex {
          pkg = "joken";
          version = "${version}";
          hash = "sha256-WpWwWnHNC1Sr01N4rrHUh6I6UsMk+n79/8UStlW1qqc=";
        };

        beamDeps = [ jose ];
      };

      jose = buildMix rec {
        name = "jose";
        version = "1.11.6";

        src = fetchHex {
          pkg = "jose";
          version = "${version}";
          hash = "sha256-YnXLdVBPnB5g7qy3ca3+7kkFqeGCEDqlm1P+1lH/lzg=";
        };

        beamDeps = [ ];
      };

      jumper = buildMix rec {
        name = "jumper";
        version = "1.0.2";

        src = fetchHex {
          pkg = "jumper";
          version = "${version}";
          hash = "sha256-m3eCQJAh4BqzwIJw4m8262KXajjBqmSy6vY0hCLxZeE=";
        };

        beamDeps = [ ];
      };

      linkify = buildMix rec {
        name = "linkify";
        version = "0.5.3";

        src = fetchHex {
          pkg = "linkify";
          version = "${version}";
          hash = "sha256-PvNaE3fUfCVQbgfBwAXqnTjXAGmdku6Sgl8CRDQlgXc=";
        };

        beamDeps = [ ];
      };

      logger_backends = buildMix rec {
        name = "logger_backends";
        version = "1.0.0";

        src = fetchHex {
          pkg = "logger_backends";
          version = "${version}";
          hash = "sha256-H6zrPn7D72ao9XRsWv0CDmOZbfb9TrjNt4nlZlrmyc4=";
        };

        beamDeps = [ ];
      };

      mail = buildMix rec {
        name = "mail";
        version = "0.3.1";

        src = fetchHex {
          pkg = "mail";
          version = "${version}";
          hash = "sha256-HbcB6JhlwdX6KWsrV7HNWHWHzKjYoaIokrNe9ajjUqY=";
        };

        beamDeps = [ ];
      };

      majic = buildMix rec {
        name = "majic";
        version = "1.0.0";

        src = fetchHex {
          pkg = "majic";
          version = "${version}";
          hash = "sha256-eQWFj3ZlDUlpXxTqVc2aqu4MZlT6ORZx1M8wXCdaCp4=";
        };

        beamDeps = [
          elixir_make
          mime
          nimble_pool
          plug
        ];
      };

      makeup = buildMix rec {
        name = "makeup";
        version = "1.0.5";

        src = fetchHex {
          pkg = "makeup";
          version = "${version}";
          hash = "sha256-z6FYwC0/XAxmXQrxFRL+0/ugFEzxqt7g8s4XdH+6LKk=";
        };

        beamDeps = [ nimble_parsec ];
      };

      makeup_elixir = buildMix rec {
        name = "makeup_elixir";
        version = "0.14.1";

        src = fetchHex {
          pkg = "makeup_elixir";
          version = "${version}";
          hash = "sha256-8kOLGoDq7J7egytcQc1PNzs4/XqjPjsi2dt55kDL3hE=";
        };

        beamDeps = [ makeup ];
      };

      makeup_erlang = buildMix rec {
        name = "makeup_erlang";
        version = "0.1.3";

        src = fetchHex {
          pkg = "makeup_erlang";
          version = "${version}";
          hash = "sha256-t43IU9LmcP9jkLYF2AcmO/YG2jyCvjf51/aGNb2Ib8k=";
        };

        beamDeps = [ makeup ];
      };

      meck = buildRebar3 rec {
        name = "meck";
        version = "0.9.2";

        src = fetchHex {
          pkg = "meck";
          version = "${version}";
          hash = "sha256-gTRPVhNX3ECoNEr6U3Z8MmaRUzVbYm6p/LyNprMEWCY=";
        };

        beamDeps = [ ];
      };

      metrics = buildRebar3 rec {
        name = "metrics";
        version = "1.0.1";

        src = fetchHex {
          pkg = "metrics";
          version = "${version}";
          hash = "sha256-abCa3dxPdKQHFq5U0UD5O+sPuJeNhjbq3tDDG28JnxY=";
        };

        beamDeps = [ ];
      };

      mime = buildMix rec {
        name = "mime";
        version = "1.6.0";

        src = fetchHex {
          pkg = "mime";
          version = "${version}";
          hash = "sha256-MaGoYT+DIRQ93h2vw2AGoX0o0Cvf7LnpWogPp6q9Gac=";
        };

        beamDeps = [ ];
      };

      mimerl = buildRebar3 rec {
        name = "mimerl";
        version = "1.3.0";

        src = fetchHex {
          pkg = "mimerl";
          version = "${version}";
          hash = "sha256-oeFaUNGIchfelfC5sHk+MoU/fCWKXNInZQiJs4g5/p0=";
        };

        beamDeps = [ ];
      };

      mint = buildMix rec {
        name = "mint";
        version = "1.6.1";

        src = fetchHex {
          pkg = "mint";
          version = "${version}";
          hash = "sha256-T8UY3MGR0C9DM5OnKnuj9vlLEB0JTLa/Uy6lTIlCN4A=";
        };

        beamDeps = [
          castore
          hpax
        ];
      };

      mochiweb = buildRebar3 rec {
        name = "mochiweb";
        version = "2.18.0";

        src = fetchHex {
          pkg = "mochiweb";
          version = "${version}";
          hash = "sha256-uT4rHlZL263+zClyd/nm0JAtpkW0F9bJIQ9gOKxjSJo=";
        };

        beamDeps = [ ];
      };

      mock = buildMix rec {
        name = "mock";
        version = "0.3.8";

        src = fetchHex {
          pkg = "mock";
          version = "${version}";
          hash = "sha256-f6gjZMl2F9ebt9FVcRk/wMT+Wv0MkyzvCUJrPub+ICI=";
        };

        beamDeps = [ meck ];
      };

      mogrify = buildMix rec {
        name = "mogrify";
        version = "0.9.3";

        src = fetchHex {
          pkg = "mogrify";
          version = "${version}";
          hash = "sha256-AYmx4d4nRV8rmujPiCOc79I9ON6Sduta3XFZrqUXMeY=";
        };

        beamDeps = [ ];
      };

      mox = buildMix rec {
        name = "mox";
        version = "1.1.0";

        src = fetchHex {
          pkg = "mox";
          version = "${version}";
          hash = "sha256-1ER0xQvgLVtyExBwKBpdOJXA56lceA6QvAz+cS9jOhM=";
        };

        beamDeps = [ ];
      };

      mua = buildMix rec {
        name = "mua";
        version = "0.2.3";

        src = fetchHex {
          pkg = "mua";
          version = "${version}";
          hash = "sha256-f+hhqH/MBqmA05QbvLJjTl8PMP1q0V72wEI/+dx+Rt4=";
        };

        beamDeps = [ castore ];
      };

      multipart = buildMix rec {
        name = "multipart";
        version = "0.4.0";

        src = fetchHex {
          pkg = "multipart";
          version = "${version}";
          hash = "sha256-PFYEvC+xezE35dKr312swmR+YMXMZjSxAs8a73Wgbwo=";
        };

        beamDeps = [ mime ];
      };

      nimble_options = buildMix rec {
        name = "nimble_options";
        version = "1.1.1";

        src = fetchHex {
          pkg = "nimble_options";
          version = "${version}";
          hash = "sha256-ghskcMqUQsS2mEiC/puwOJNxuN3sTUWpUE8Apm9lC0Q=";
        };

        beamDeps = [ ];
      };

      nimble_parsec = buildMix rec {
        name = "nimble_parsec";
        version = "0.6.0";

        src = fetchHex {
          pkg = "nimble_parsec";
          version = "${version}";
          hash = "sha256-J+rDFalJCdTcaLwHpKg+Bsg3kjfF6lKKms/0yhyHPFI=";
        };

        beamDeps = [ ];
      };

      nimble_pool = buildMix rec {
        name = "nimble_pool";
        version = "0.2.6";

        src = fetchHex {
          pkg = "nimble_pool";
          version = "${version}";
          hash = "sha256-HHFQVQldPycFxOI2wYthhCCjVJDalBSf+LWAohRPZT8=";
        };

        beamDeps = [ ];
      };

      oban = buildMix rec {
        name = "oban";
        version = "2.18.3";

        src = fetchHex {
          pkg = "oban";
          version = "${version}";
          hash = "sha256-NspsqE72UY+cLHWeqI79Q4o8gdZnuiOwKwYqCqeFR14=";
        };

        beamDeps = [
          ecto_sql
          jason
          postgrex
          telemetry
        ];
      };

      oban_live_dashboard = buildMix rec {
        name = "oban_live_dashboard";
        version = "0.1.1";

        src = fetchHex {
          pkg = "oban_live_dashboard";
          version = "${version}";
          hash = "sha256-FtxM6cmpWqLmVeNe1OZ1ZSmUqN72FzGhivheIw4cqmM=";
        };

        beamDeps = [
          oban
          phoenix_live_dashboard
        ];
      };

      octo_fetch = buildMix rec {
        name = "octo_fetch";
        version = "0.4.0";

        src = fetchHex {
          pkg = "octo_fetch";
          version = "${version}";
          hash = "sha256-z4vm9AzVGdcAC7ToStz2YcMuWTacooJ8TiAELtp6f8Y=";
        };

        beamDeps = [
          castore
          ssl_verify_fun
        ];
      };

      open_api_spex = buildMix rec {
        name = "open_api_spex";
        version = "3.18.2";

        src = fetchHex {
          pkg = "open_api_spex";
          version = "${version}";
          hash = "sha256-qj5tz8CtagJZayFyZi2iHJ3YSNrBReqeYD9U49gbjSs=";
        };

        beamDeps = [
          jason
          plug
          poison
        ];
      };

      parse_trans = buildRebar3 rec {
        name = "parse_trans";
        version = "3.4.1";

        src = fetchHex {
          pkg = "parse_trans";
          version = "${version}";
          hash = "sha256-YgpAbOddragnuC5FPBnPBndr4mb1pnz/NOHvLLtg5Jo=";
        };

        beamDeps = [ ];
      };

      pbkdf2_elixir = buildMix rec {
        name = "pbkdf2_elixir";
        version = "1.2.1";

        src = fetchHex {
          pkg = "pbkdf2_elixir";
          version = "${version}";
          hash = "sha256-07QKSkYw8LRC8Z7KiR/P7u5MQIcZNv7S9o4cT6owSB8=";
        };

        beamDeps = [ comeonin ];
      };

      phoenix_ecto = buildMix rec {
        name = "phoenix_ecto";
        version = "4.4.3";

        src = fetchHex {
          pkg = "phoenix_ecto";
          version = "${version}";
          hash = "sha256-02xAEgbzAR/v1j0E6O9ibsh5GXXZ0Qf5oIF9Qm9hrAc=";
        };

        beamDeps = [
          ecto
          phoenix_html
          plug
        ];
      };

      phoenix_html = buildMix rec {
        name = "phoenix_html";
        version = "3.3.4";

        src = fetchHex {
          pkg = "phoenix_html";
          version = "${version}";
          hash = "sha256-AknTq+w3FK/zQV5+49l4bLMlvjFR5sSzAhUCxYW/U/s=";
        };

        beamDeps = [ plug ];
      };

      phoenix_live_dashboard = buildMix rec {
        name = "phoenix_live_dashboard";
        version = "0.8.3";

        src = fetchHex {
          pkg = "phoenix_live_dashboard";
          version = "${version}";
          hash = "sha256-+UcKCouuT1ZDCiPUL5d7WmIF/bplWddvkyuHa/rsZS0=";
        };

        beamDeps = [
          ecto
          ecto_psql_extras
          mime
          phoenix_live_view
          telemetry_metrics
        ];
      };

      phoenix_live_reload = buildMix rec {
        name = "phoenix_live_reload";
        version = "1.3.3";

        src = fetchHex {
          pkg = "phoenix_live_reload";
          version = "${version}";
          hash = "sha256-dmeWZ25fVY265dG9sGaElnPpVgBeNzDf1a/9em2kq6w=";
        };

        beamDeps = [
          file_system
          phoenix
        ];
      };

      phoenix_live_view = buildMix rec {
        name = "phoenix_live_view";
        version = "0.19.5";

        src = fetchHex {
          pkg = "phoenix_live_view";
          version = "${version}";
          hash = "sha256-suqg3Tz7m9f7lJuIIX358lrtkV6YaiitXIoNBU58qdM=";
        };

        beamDeps = [
          jason
          phoenix
          phoenix_html
          phoenix_template
          phoenix_view
          telemetry
        ];
      };

      phoenix_pubsub = buildMix rec {
        name = "phoenix_pubsub";
        version = "2.1.3";

        src = fetchHex {
          pkg = "phoenix_pubsub";
          version = "${version}";
          hash = "sha256-u6Brwdz9jLCGdZ8O3JSouivIiW1TMaHiwpAr+ONu5QI=";
        };

        beamDeps = [ ];
      };

      phoenix_swoosh = buildMix rec {
        name = "phoenix_swoosh";
        version = "1.2.1";

        src = fetchHex {
          pkg = "phoenix_swoosh";
          version = "${version}";
          hash = "sha256-QADuuj+dfRpr9W0r1Wcz1crfQafw2P/lu2fn1mfiBKI=";
        };

        beamDeps = [
          finch
          hackney
          phoenix
          phoenix_html
          phoenix_view
          swoosh
        ];
      };

      phoenix_template = buildMix rec {
        name = "phoenix_template";
        version = "1.0.4";

        src = fetchHex {
          pkg = "phoenix_template";
          version = "${version}";
          hash = "sha256-LAyB8OXGdT+vXMovIpyXCZGaujT6uGbTvAUGDJxEQgY=";
        };

        beamDeps = [ phoenix_html ];
      };

      phoenix_view = buildMix rec {
        name = "phoenix_view";
        version = "2.0.4";

        src = fetchHex {
          pkg = "phoenix_view";
          version = "${version}";
          hash = "sha256-TpkgIs4U8x/lczXbJ6KBVK/MlOmYMmaDW7MEAkPrYgs=";
        };

        beamDeps = [
          phoenix_html
          phoenix_template
        ];
      };

      plug = buildMix rec {
        name = "plug";
        version = "1.16.1";

        src = fetchHex {
          pkg = "plug";
          version = "${version}";
          hash = "sha256-oT/2uQBrA9fjOHSUWydVJThBsjjDQHHthbDoYFf4zdw=";
        };

        beamDeps = [
          mime
          plug_crypto
          telemetry
        ];
      };

      plug_cowboy = buildMix rec {
        name = "plug_cowboy";
        version = "2.7.1";

        src = fetchHex {
          pkg = "plug_cowboy";
          version = "${version}";
          hash = "sha256-AtvV+atXG4ZK45QY23gRYYUGJW9tE7SkUDfl/njcXeM=";
        };

        beamDeps = [
          cowboy
          cowboy_telemetry
          plug
        ];
      };

      plug_crypto = buildMix rec {
        name = "plug_crypto";
        version = "2.1.0";

        src = fetchHex {
          pkg = "plug_crypto";
          version = "${version}";
          hash = "sha256-ExIWpLAwuPjODyYDi8RCGuYOS7lcXPU5XhQhQ3gkxPo=";
        };

        beamDeps = [ ];
      };

      plug_static_index_html = buildMix rec {
        name = "plug_static_index_html";
        version = "1.0.0";

        src = fetchHex {
          pkg = "plug_static_index_html";
          version = "${version}";
          hash = "sha256-ef1PzzTREGBcJlYMuujyPGA+xBWMCCmL1DYP3qkLtc8=";
        };

        beamDeps = [ plug ];
      };

      poison = buildMix rec {
        name = "poison";
        version = "3.1.0";

        src = fetchHex {
          pkg = "poison";
          version = "${version}";
          hash = "sha256-/shmDrdzPuQRe4X1V5n9ODPrdppt9xzPiQPo3FRHz84=";
        };

        beamDeps = [ ];
      };

      poolboy = buildRebar3 rec {
        name = "poolboy";
        version = "1.5.2";

        src = fetchHex {
          pkg = "poolboy";
          version = "${version}";
          hash = "sha256-2teXBM5UQPPVo2gchZC53CXRpWHo9anJlSgQEoYJAeM=";
        };

        beamDeps = [ ];
      };

      postgrex = buildMix rec {
        name = "postgrex";
        version = "0.17.5";

        src = fetchHex {
          pkg = "postgrex";
          version = "${version}";
          hash = "sha256-ULixGvuyxAlaO6Z1tPBVxBbQ89feZjOllfwTGoKKZ+s=";
        };

        beamDeps = [
          db_connection
          decimal
          jason
        ];
      };

      pot = buildRebar3 rec {
        name = "pot";
        version = "1.0.2";

        src = fetchHex {
          pkg = "pot";
          version = "${version}";
          hash = "sha256-eP4Sf1pPX5GdbqWipnGCe9U+udN+W0EowK09+ZhWwuA=";
        };

        beamDeps = [ ];
      };

      prom_ex = buildMix rec {
        name = "prom_ex";
        version = "1.9.0";

        src = fetchHex {
          pkg = "prom_ex";
          version = "${version}";
          hash = "sha256-AfPU9p7JMGghnmhsxl5YopxCvqVCmo/04hIfGdsXjuY=";
        };

        beamDeps = [
          ecto
          finch
          jason
          oban
          octo_fetch
          phoenix
          phoenix_live_view
          plug
          plug_cowboy
          telemetry
          telemetry_metrics
          telemetry_metrics_prometheus_core
          telemetry_poller
        ];
      };

      prometheus = buildMix rec {
        name = "prometheus";
        version = "4.10.0";

        src = fetchHex {
          pkg = "prometheus";
          version = "${version}";
          hash = "sha256-Kpm7bc6F4jjHI2/eawBk+YNNxCDdvZYqrE6io8PVk4Q=";
        };

        beamDeps = [ quantile_estimator ];
      };

      prometheus_ecto = buildMix rec {
        name = "prometheus_ecto";
        version = "1.4.3";

        src = fetchHex {
          pkg = "prometheus_ecto";
          version = "${version}";
          hash = "sha256-jWYon3f5E7N+2oH9KHNAwX5hpEdUneso78JUUysr7YI=";
        };

        beamDeps = [
          ecto
          prometheus_ex
        ];
      };

      prometheus_plugs = buildMix rec {
        name = "prometheus_plugs";
        version = "1.1.5";

        src = fetchHex {
          pkg = "prometheus_plugs";
          version = "${version}";
          hash = "sha256-AnOmSDzLk215yhmwq2Ka7w26lYaXyUeCu3KLkg38ank=";
        };

        beamDeps = [
          accept
          plug
          prometheus_ex
        ];
      };

      quantile_estimator = buildRebar3 rec {
        name = "quantile_estimator";
        version = "0.2.1";

        src = fetchHex {
          pkg = "quantile_estimator";
          version = "${version}";
          hash = "sha256-KCqKMjyiqEXJ5veH0WY0j3dsHUpB7eYwRtctQi49qUY=";
        };

        beamDeps = [ ];
      };

      ranch = buildRebar3 rec {
        name = "ranch";
        version = "1.8.0";

        src = fetchHex {
          pkg = "ranch";
          version = "${version}";
          hash = "sha256-SfvP02gvqx9dEJNRthJXZ22hov2+KVkEF21eUhot3+U=";
        };

        beamDeps = [ ];
      };

      recon = buildMix rec {
        name = "recon";
        version = "2.5.4";

        src = fetchHex {
          pkg = "recon";
          version = "${version}";
          hash = "sha256-6asBrH/IVy5B61k4Xv6z+w/1vwIQOBZTW6yu3zJ9AmM=";
        };

        beamDeps = [ ];
      };

      rustler = buildMix rec {
        name = "rustler";
        version = "0.30.0";

        src = fetchHex {
          pkg = "rustler";
          version = "${version}";
          hash = "sha256-nvGrtqfdo1xHz8ZJ5qWmFmOvbPhCpVgUpVSoRgfe44k=";
        };

        beamDeps = [
          jason
          toml
        ];
      };

      sleeplocks = buildRebar3 rec {
        name = "sleeplocks";
        version = "1.1.2";

        src = fetchHex {
          pkg = "sleeplocks";
          version = "${version}";
          hash = "sha256-n+XQSMW3gdYwXBo6D0C7PfwG9Jv0BXHz0tDFfqp/WaU=";
        };

        beamDeps = [ ];
      };

      ssl_verify_fun = buildRebar3 rec {
        name = "ssl_verify_fun";
        version = "1.1.7";

        src = fetchHex {
          pkg = "ssl_verify_fun";
          version = "${version}";
          hash = "sha256-/kwZDo83QB0wFnyMQF7aGUafNFd5h8dt3mE+g4u8Z/g=";
        };

        beamDeps = [ ];
      };

      statistex = buildMix rec {
        name = "statistex";
        version = "1.0.0";

        src = fetchHex {
          pkg = "statistex";
          version = "${version}";
          hash = "sha256-/52L7nA1Aoq0dC/1L8gKKqNc7Ogzz1MZAJtS8bWobCc=";
        };

        beamDeps = [ ];
      };

      sweet_xml = buildMix rec {
        name = "sweet_xml";
        version = "0.7.4";

        src = fetchHex {
          pkg = "sweet_xml";
          version = "${version}";
          hash = "sha256-58Swvb9GDJKCNJUd71T+h+3xoXD2iWZ1RDJ54tvroWc=";
        };

        beamDeps = [ ];
      };

      swoosh = buildMix rec {
        name = "swoosh";
        version = "1.16.9";

        src = fetchHex {
          pkg = "swoosh";
          version = "${version}";
          hash = "sha256-h4saemwQ679yWjNJNj9I95xePXkutiFkOw0najiswKY=";
        };

        beamDeps = [
          bandit
          cowboy
          ex_aws
          finch
          gen_smtp
          hackney
          jason
          mail
          mime
          mua
          multipart
          plug
          plug_cowboy
          telemetry
        ];
      };

      syslog = buildRebar3 rec {
        name = "syslog";
        version = "1.1.0";

        src = fetchHex {
          pkg = "syslog";
          version = "${version}";
          hash = "sha256-TGpBNzx+IFh74z74QdPebzvroIUZgJMp7MTSexW2WeE=";
        };

        beamDeps = [ ];
      };

      table_rex = buildMix rec {
        name = "table_rex";
        version = "4.0.0";

        src = fetchHex {
          pkg = "table_rex";
          version = "${version}";
          hash = "sha256-w1xNVhLKSeuwNE6hA4faTSr+J4OH1AGeTYER6BXfj1U=";
        };

        beamDeps = [ ];
      };

      telemetry = buildRebar3 rec {
        name = "telemetry";
        version = "1.0.0";

        src = fetchHex {
          pkg = "telemetry";
          version = "${version}";
          hash = "sha256-c7wJ+lm0oChO+0YkM1WDxSjgfsmudqypbqBnOFCuxXo=";
        };

        beamDeps = [ ];
      };

      telemetry_metrics = buildMix rec {
        name = "telemetry_metrics";
        version = "0.6.2";

        src = fetchHex {
          pkg = "telemetry_metrics";
          version = "${version}";
          hash = "sha256-m0PbDcM4Y5MLnvnScTfniXR1b18ZjK4YQJlw7W+ltWE=";
        };

        beamDeps = [ telemetry ];
      };

      telemetry_metrics_prometheus_core = buildMix rec {
        name = "telemetry_metrics_prometheus_core";
        version = "1.2.0";

        src = fetchHex {
          pkg = "telemetry_metrics_prometheus_core";
          version = "${version}";
          hash = "sha256-nLqVDhxHM0aO++P4IYQfNKwF0o5693mGIviOzbvmPqM=";
        };

        beamDeps = [
          telemetry
          telemetry_metrics
        ];
      };

      telemetry_poller = buildRebar3 rec {
        name = "telemetry_poller";
        version = "1.0.0";

        src = fetchHex {
          pkg = "telemetry_poller";
          version = "${version}";
          hash = "sha256-s6JOr9ZsP0LaMPw8p92h6dVGwSJQotYNe4HSZPvsT24=";
        };

        beamDeps = [ telemetry ];
      };

      tesla = buildMix rec {
        name = "tesla";
        version = "1.11.0";

        src = fetchHex {
          pkg = "tesla";
          version = "${version}";
          hash = "sha256-uDq11MLSAuHqK34XpJ94jUmmmVE9fE8I8q7ywoG+ads=";
        };

        beamDeps = [
          castore
          finch
          gun
          hackney
          jason
          mime
          mint
          poison
          telemetry
        ];
      };

      thousand_island = buildMix rec {
        name = "thousand_island";
        version = "1.3.5";

        src = fetchHex {
          pkg = "thousand_island";
          version = "${version}";
          hash = "sha256-K+aVSRb9/kdWrzI5+2ttddC4Bjtd8Dunb9ikyHhJ4YA=";
        };

        beamDeps = [ telemetry ];
      };

      timex = buildMix rec {
        name = "timex";
        version = "3.7.7";

        src = fetchHex {
          pkg = "timex";
          version = "${version}";
          hash = "sha256-DsSwnyX+MRMh+fwEFEp+Ov/kjrKUgdelWDhJtsTfoKc=";
        };

        beamDeps = [
          combine
          gettext
          tzdata
        ];
      };

      toml = buildMix rec {
        name = "toml";
        version = "0.7.0";

        src = fetchHex {
          pkg = "toml";
          version = "${version}";
          hash = "sha256-BpAkaiR4wd79EAsMm4m06igKIr6aezE6igWKJAii+nA=";
        };

        beamDeps = [ ];
      };

      trailing_format_plug = buildMix rec {
        name = "trailing_format_plug";
        version = "0.0.7";

        src = fetchHex {
          pkg = "trailing_format_plug";
          version = "${version}";
          hash = "sha256-vU/eTBXz6ZOpmeAZ1kNHSJuRt6kJavaLK9rdGSr6aT8=";
        };

        beamDeps = [ plug ];
      };

      tzdata = buildMix rec {
        name = "tzdata";
        version = "1.0.5";

        src = fetchHex {
          pkg = "tzdata";
          version = "${version}";
          hash = "sha256-VVGaoqmeXSCVweYcx0yb5paI+Kt1wn2nJOuCef9AKlo=";
        };

        beamDeps = [ hackney ];
      };

      ueberauth = buildMix rec {
        name = "ueberauth";
        version = "0.10.7";

        src = fetchHex {
          pkg = "ueberauth";
          version = "${version}";
          hash = "sha256-C8z3Pi/9YzeXE0CDKUe6Iyh3qoEi26TJW+n3KciYc3c=";
        };

        beamDeps = [ plug ];
      };

      unicode_util_compat = buildRebar3 rec {
        name = "unicode_util_compat";
        version = "0.7.0";

        src = fetchHex {
          pkg = "unicode_util_compat";
          version = "${version}";
          hash = "sha256-Je7m1n32GWDPanlCOVZlmbCeF+Zo03ACR7xJhjgVJSE=";
        };

        beamDeps = [ ];
      };

      unsafe = buildMix rec {
        name = "unsafe";
        version = "1.0.2";

        src = fetchHex {
          pkg = "unsafe";
          version = "${version}";
          hash = "sha256-tIUjFoPDqwGpzUTLSnnxUsbzu4c1hDnG9oeRuFwt9nU=";
        };

        beamDeps = [ ];
      };

      vix = buildMix rec {
        name = "vix";
        version = "0.26.0";

        src = fetchHex {
          pkg = "vix";
          version = "${version}";
          hash = "sha256-cbCnmufxmcrPyOZ5sOS6Je5H3ALhgsW5CX77KfvhTv0=";
        };

        beamDeps = [
          castore
          cc_precompiler
          elixir_make
        ];
      };

      web_push_encryption = buildMix rec {
        name = "web_push_encryption";
        version = "0.3.1";

        src = fetchHex {
          pkg = "web_push_encryption";
          version = "${version}";
          hash = "sha256-T4Ky5XYi+5M3VZBY6Hl8sN9+fJeQeTvcTkC8iV9w4qI=";
        };

        beamDeps = [
          httpoison
          jose
        ];
      };

      websock = buildMix rec {
        name = "websock";
        version = "0.5.3";

        src = fetchHex {
          pkg = "websock";
          version = "${version}";
          hash = "sha256-YQVFPX+sIscSrWb6sdRavfBJho8lPPcZtiUVFGC4tFM=";
        };

        beamDeps = [ ];
      };

      websock_adapter = buildMix rec {
        name = "websock_adapter";
        version = "0.5.6";

        src = fetchHex {
          pkg = "websock_adapter";
          version = "${version}";
          hash = "sha256-4EN40msK9ieBeuhMkgg7fpesoxIRlmebc8c7mdDRM+o=";
        };

        beamDeps = [
          bandit
          plug
          plug_cowboy
          websock
        ];
      };

      websockex = buildMix rec {
        name = "websockex";
        version = "0.4.3";

        src = fetchHex {
          pkg = "websockex";
          version = "${version}";
          hash = "sha256-lfLnByuFo6TMOFYC1CEVtzzgt0qRIdDW279VdkWsU+Q=";
        };

        beamDeps = [ ];
      };
    };
in
self
