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
      absinthe = buildMix rec {
        name = "absinthe";
        version = "1.7.6";

        src = fetchHex {
          pkg = "absinthe";
          version = "${version}";
          hash = "sha256-52JpUcpe7GJ9qWBhW1EAnzp3R2VAb/AnIrHYGPF+V3g=";
        };

        beamDeps = [
          dataloader
          decimal
          nimble_parsec
          telemetry
        ];
      };

      absinthe_phoenix = buildMix rec {
        name = "absinthe_phoenix";
        version = "2.0.2";

        src = fetchHex {
          pkg = "absinthe_phoenix";
          version = "${version}";
          hash = "sha256-02kYklw4DcfS7X0DnJo7QYLsNnI/dBemh0Wt5aqyL40=";
        };

        beamDeps = [
          absinthe
          absinthe_plug
          decimal
          phoenix
          phoenix_html
          phoenix_pubsub
        ];
      };

      absinthe_plug = buildMix rec {
        name = "absinthe_plug";
        version = "1.5.8";

        src = fetchHex {
          pkg = "absinthe_plug";
          version = "${version}";
          hash = "sha256-u7BBdmR7c1gohh57JwVGXlPiz1TM9ac93R69hV+Zblo=";
        };

        beamDeps = [
          absinthe
          plug
        ];
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

      atomex = buildMix rec {
        name = "atomex";
        version = "0.5.1";

        src = fetchHex {
          pkg = "atomex";
          version = "${version}";
          hash = "sha256-YkiJG1/KuFA5guCQ7t7q23V6YxHC7y4pmLh099MZqz8=";
        };

        beamDeps = [ xml_builder ];
      };

      bandit = buildMix rec {
        name = "bandit";
        version = "1.2.3";

        src = fetchHex {
          pkg = "bandit";
          version = "${version}";
          hash = "sha256-PikVAkWptfVpRENOUkCWbnXJF9rSSPaJq1ibMhh6ga8=";
        };

        beamDeps = [
          hpax
          plug
          telemetry
          thousand_island
          websock
        ];
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

      castore = buildMix rec {
        name = "castore";
        version = "1.0.5";

        src = fetchHex {
          pkg = "castore";
          version = "${version}";
          hash = "sha256-jXxZfD5KZMOVmAiC1LyjzruNdBl8WQ3Ccs/TtqYxBXg=";
        };

        beamDeps = [ ];
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

      cldr_utils = buildMix rec {
        name = "cldr_utils";
        version = "2.24.2";

        src = fetchHex {
          pkg = "cldr_utils";
          version = "${version}";
          hash = "sha256-M2K4OINqnw+jCd4JpxJ+NuZzEOeX1VbbkvcbVIgyx88=";
        };

        beamDeps = [
          castore
          certifi
          decimal
        ];
      };

      codepagex = buildMix rec {
        name = "codepagex";
        version = "0.1.6";

        src = fetchHex {
          pkg = "codepagex";
          version = "${version}";
          hash = "sha256-FSFGEJfd4oHt8IQGL1JaTtxqXkn0/R9exBycSVXVvVk=";
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

      cors_plug = buildMix rec {
        name = "cors_plug";
        version = "3.0.3";

        src = fetchHex {
          pkg = "cors_plug";
          version = "${version}";
          hash = "sha256-Py11nownLtODX6su8RtGvdq4wauVKBZ71GO2RS7fgw0=";
        };

        beamDeps = [ plug ];
      };

      credo = buildMix rec {
        name = "credo";
        version = "1.7.5";

        src = fetchHex {
          pkg = "credo";
          version = "${version}";
          hash = "sha256-95nptc0YkVd9jHc9JFZoqnSi/NFesnf1GgExaQ6/s/0=";
        };

        beamDeps = [
          bunt
          file_system
          jason
        ];
      };

      credo_code_climate = buildMix rec {
        name = "credo_code_climate";
        version = "0.1.0";

        src = fetchHex {
          pkg = "credo_code_climate";
          version = "${version}";
          hash = "sha256-dVKf44BW9OIpgh1gR1goKDi4OXyC4sEuQJ/aFrFoIco=";
        };

        beamDeps = [
          credo
          jason
        ];
      };

      dataloader = buildMix rec {
        name = "dataloader";
        version = "2.0.0";

        src = fetchHex {
          pkg = "dataloader";
          version = "${version}";
          hash = "sha256-CdYXgbds4hbjlc28iD/wDQD0alA+IVwici26glB9/vA=";
        };

        beamDeps = [
          ecto
          telemetry
        ];
      };

      db_connection = buildMix rec {
        name = "db_connection";
        version = "2.6.0";

        src = fetchHex {
          pkg = "db_connection";
          version = "${version}";
          hash = "sha256-wvmS0Vcl5yHsf7wRidTs24r+92ZIx0ao4crTXjuKNfM=";
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

      digital_token = buildMix rec {
        name = "digital_token";
        version = "0.6.0";

        src = fetchHex {
          pkg = "digital_token";
          version = "${version}";
          hash = "sha256-JFXWJufGGhKLAqSoyt2wklSMPrYTrG9qheTLtsrdxNE=";
        };

        beamDeps = [
          cldr_utils
          jason
        ];
      };

      doctor = buildMix rec {
        name = "doctor";
        version = "0.21.0";

        src = fetchHex {
          pkg = "doctor";
          version = "${version}";
          hash = "sha256-oieDHap5eE6yTN7t+kA8RqTLfQ6rDjEjLsZUMURH5OA=";
        };

        beamDeps = [ decimal ];
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

      eblurhash = buildRebar3 rec {
        name = "eblurhash";
        version = "1.2.2";

        src = fetchHex {
          pkg = "eblurhash";
          version = "${version}";
          hash = "sha256-jCDKAJBN4COoNanct7d2L+0yJkyFqAw8r6hSiOQFBEw=";
        };

        beamDeps = [ ];
      };

      ecto = buildMix rec {
        name = "ecto";
        version = "3.11.1";

        src = fetchHex {
          pkg = "ecto";
          version = "${version}";
          hash = "sha256-69PTdyzQ382NdyZZ5B7VJ8KLKoveSwD+A+BGPaDxmDs=";
        };

        beamDeps = [
          decimal
          jason
          telemetry
        ];
      };

      ecto_autoslug_field = buildMix rec {
        name = "ecto_autoslug_field";
        version = "3.1.0";

        src = fetchHex {
          pkg = "ecto_autoslug_field";
          version = "${version}";
          hash = "sha256-tt3WFIBSY+JLXBaVMsk0RA0CiRgczocwYfyjqOkv2f8=";
        };

        beamDeps = [
          ecto
          slugify
        ];
      };

      ecto_dev_logger = buildMix rec {
        name = "ecto_dev_logger";
        version = "0.10.0";

        src = fetchHex {
          pkg = "ecto_dev_logger";
          version = "${version}";
          hash = "sha256-pV5YutXVybjvKjwzR9vffvqIClNxzxRX5EtB9ImkOSc=";
        };

        beamDeps = [
          ecto
          jason
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

      ecto_shortuuid = buildMix rec {
        name = "ecto_shortuuid";
        version = "0.2.0";

        src = fetchHex {
          pkg = "ecto_shortuuid";
          version = "${version}";
          hash = "sha256-uS47cehr6S9afvbz3hcOeGRFTmMPewHdkwQUuvOO+2U=";
        };

        beamDeps = [
          ecto
          shortuuid
        ];
      };

      ecto_sql = buildMix rec {
        name = "ecto_sql";
        version = "3.11.1";

        src = fetchHex {
          pkg = "ecto_sql";
          version = "${version}";
          hash = "sha256-zhQGOrNRRCQnbn42AQitbCMI9tiBZKB2qsijh+H+pjQ=";
        };

        beamDeps = [
          db_connection
          ecto
          postgrex
          telemetry
        ];
      };

      elixir_feed_parser = buildMix rec {
        name = "elixir_feed_parser";
        version = "2.1.0";

        src = fetchHex {
          pkg = "elixir_feed_parser";
          version = "${version}";
          hash = "sha256-LTxi/ns5buO3PXFgvI+tvXi/6Vl8mMfXmz8QONnLoo8=";
        };

        beamDeps = [ timex ];
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

      erlport = buildRebar3 rec {
        name = "erlport";
        version = "0.11.0";

        src = fetchHex {
          pkg = "erlport";
          version = "${version}";
          hash = "sha256-jrE2zK85SNMpuNHDJ4rS4X4qcxmAG8TMLabbJ4IE7uQ=";
        };

        beamDeps = [ ];
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

      ex_cldr = buildMix rec {
        name = "ex_cldr";
        version = "2.37.5";

        src = fetchHex {
          pkg = "ex_cldr";
          version = "${version}";
          hash = "sha256-dK1d3/eRESzkFWOC4XGl9dN2avnVxGdeBXHwgf4TZHk=";
        };

        beamDeps = [
          cldr_utils
          decimal
          gettext
          jason
          nimble_parsec
        ];
      };

      ex_cldr_calendars = buildMix rec {
        name = "ex_cldr_calendars";
        version = "1.23.0";

        src = fetchHex {
          pkg = "ex_cldr_calendars";
          version = "${version}";
          hash = "sha256-BtJAfmmQMtXNxRVZO3znhp8Qzijpik7WjZsh5QAQNtQ=";
        };

        beamDeps = [
          ex_cldr_numbers
          ex_doc
          jason
        ];
      };

      ex_cldr_currencies = buildMix rec {
        name = "ex_cldr_currencies";
        version = "2.15.1";

        src = fetchHex {
          pkg = "ex_cldr_currencies";
          version = "${version}";
          hash = "sha256-Md+L03aINA+IGb3XcOsX1lllIHjTTbYyuF1KMoZNaiU=";
        };

        beamDeps = [
          ex_cldr
          jason
        ];
      };

      ex_cldr_dates_times = buildMix rec {
        name = "ex_cldr_dates_times";
        version = "2.16.0";

        src = fetchHex {
          pkg = "ex_cldr_dates_times";
          version = "${version}";
          hash = "sha256-Dy8lDUecrdpODvOl49k2rnuho/EZnbZ5HihOhiA0lbE=";
        };

        beamDeps = [
          ex_cldr_calendars
          ex_cldr_numbers
          jason
        ];
      };

      ex_cldr_languages = buildMix rec {
        name = "ex_cldr_languages";
        version = "0.3.3";

        src = fetchHex {
          pkg = "ex_cldr_languages";
          version = "${version}";
          hash = "sha256-Ivsf73K3tLSHLSQ7NOe4NzQkenithzd5hr9xkInMRHo=";
        };

        beamDeps = [
          ex_cldr
          jason
        ];
      };

      ex_cldr_numbers = buildMix rec {
        name = "ex_cldr_numbers";
        version = "2.32.4";

        src = fetchHex {
          pkg = "ex_cldr_numbers";
          version = "${version}";
          hash = "sha256-b9WoLweFQY+otpjAvisYRd/5K3fxsxcsdj03ho+1A9I=";
        };

        beamDeps = [
          decimal
          digital_token
          ex_cldr
          ex_cldr_currencies
          jason
        ];
      };

      ex_cldr_plugs = buildMix rec {
        name = "ex_cldr_plugs";
        version = "1.3.1";

        src = fetchHex {
          pkg = "ex_cldr_plugs";
          version = "${version}";
          hash = "sha256-T3tKX+Bhc0zve2L/KRGO1qxyaYzde8/JdJXbc2Ef4P4=";
        };

        beamDeps = [
          ex_cldr
          gettext
          jason
          plug
        ];
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

      ex_ical = buildMix rec {
        name = "ex_ical";
        version = "0.2.0";

        src = fetchHex {
          pkg = "ex_ical";
          version = "${version}";
          hash = "sha256-23ZHOyrgJZ5mM8bEeaWk2GA/CUl/VciPnvTVPSt1vvs=";
        };

        beamDeps = [ timex ];
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

      ex_optimizer = buildMix rec {
        name = "ex_optimizer";
        version = "0.1.1";

        src = fetchHex {
          pkg = "ex_optimizer";
          version = "${version}";
          hash = "sha256-5vXAWbzVi2a+L28lf9xPabdLD6XJ3dZpSGrwEuS1IoY=";
        };

        beamDeps = [ file_info ];
      };

      ex_unit_notifier = buildMix rec {
        name = "ex_unit_notifier";
        version = "1.3.0";

        src = fetchHex {
          pkg = "ex_unit_notifier";
          version = "${version}";
          hash = "sha256-Vf/9YGLo2WL8ROiwb6MKh9xyUe4qafUgeBo7sphYw2U=";
        };

        beamDeps = [ ];
      };

      excoveralls = buildMix rec {
        name = "excoveralls";
        version = "0.18.0";

        src = fetchHex {
          pkg = "excoveralls";
          version = "${version}";
          hash = "sha256-EQm7kR88tYNAF2C+ScAsu9Fq7WbqlQn8VHkzXShNpgs=";
        };

        beamDeps = [
          castore
          jason
        ];
      };

      exgravatar = buildMix rec {
        name = "exgravatar";
        version = "2.0.3";

        src = fetchHex {
          pkg = "exgravatar";
          version = "${version}";
          hash = "sha256-rKGP+b2JkdO+PlRG073vwFG+CEwf/Jqy1Ds+ZTOTAOE=";
        };

        beamDeps = [ ];
      };

      expo = buildMix rec {
        name = "expo";
        version = "0.5.2";

        src = fetchHex {
          pkg = "expo";
          version = "${version}";
          hash = "sha256-jJv6BsoBfJy0Ag+r6YC8f9sarsBZ/QBMKrO/8DscWZw=";
        };

        beamDeps = [ ];
      };

      export = buildMix rec {
        name = "export";
        version = "0.1.1";

        src = fetchHex {
          pkg = "export";
          version = "${version}";
          hash = "sha256-PadET/QFPxgkNS9L2xP70sKMk8IBF4b7aGtkn9yhAh8=";
        };

        beamDeps = [ erlport ];
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

      file_info = buildMix rec {
        name = "file_info";
        version = "0.0.4";

        src = fetchHex {
          pkg = "file_info";
          version = "${version}";
          hash = "sha256-UOetAcLIuTOQEGdf5NxKETuNbKft3OJNHXT9DnYngaU=";
        };

        beamDeps = [ mimetype_parser ];
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

      floki = buildMix rec {
        name = "floki";
        version = "0.35.4";

        src = fetchHex {
          pkg = "floki";
          version = "${version}";
          hash = "sha256-J/oYXTRpvY/FlH7w+NXE5H8K8C62sHC2PIaPaeOvAgQ=";
        };

        beamDeps = [ ];
      };

      gen_smtp = buildRebar3 rec {
        name = "gen_smtp";
        version = "1.2.0";

        src = fetchHex {
          pkg = "gen_smtp";
          version = "${version}";
          hash = "sha256-XuA3VoC8qPIMTYX1jCiURBRDp0M1VDD/M6eD/gMpZ3k=";
        };

        beamDeps = [ ranch ];
      };

      geo = buildMix rec {
        name = "geo";
        version = "3.6.0";

        src = fetchHex {
          pkg = "geo";
          version = "${version}";
          hash = "sha256-Hb3r9hcYO1S8PIrXo2Uxqadq2oypP3X1c7CulABhaNo=";
        };

        beamDeps = [ jason ];
      };

      geo_postgis = buildMix rec {
        name = "geo_postgis";
        version = "3.5.0";

        src = fetchHex {
          pkg = "geo_postgis";
          version = "${version}";
          hash = "sha256-C+vFsA+LEYNQZr1iE/vu7ANwS0ocIGkguBwewiAdGF8=";
        };

        beamDeps = [
          ecto
          geo
          jason
          postgrex
        ];
      };

      geohax = buildMix rec {
        name = "geohax";
        version = "1.0.0";

        src = fetchHex {
          pkg = "geohax";
          version = "${version}";
          hash = "sha256-iT7y+QUhOstnxhXSyVXZJrG+Nna/wr1e1ycbZB36IiQ=";
        };

        beamDeps = [ ];
      };

      geolix = buildMix rec {
        name = "geolix";
        version = "2.0.0";

        src = fetchHex {
          pkg = "geolix";
          version = "${version}";
          hash = "sha256-h0K/WI7Qu33vLEQyBNCdNVmQhGxu/f+W3tZqrCTDAd8=";
        };

        beamDeps = [ ];
      };

      geolix_adapter_mmdb2 = buildMix rec {
        name = "geolix_adapter_mmdb2";
        version = "0.6.0";

        src = fetchHex {
          pkg = "geolix_adapter_mmdb2";
          version = "${version}";
          hash = "sha256-Bv+WL+rooxDP/fhrdL/NpuLQ3MtDm7H2LfK2V7HAJps=";
        };

        beamDeps = [
          geolix
          mmdb2_decoder
        ];
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

      guardian = buildMix rec {
        name = "guardian";
        version = "2.3.2";

        src = fetchHex {
          pkg = "guardian";
          version = "${version}";
          hash = "sha256-sYn/OM1GoiqKgkhmpoZ8qHIpQjR/E8M/fSMSaviCG1I=";
        };

        beamDeps = [
          jose
          plug
        ];
      };

      guardian_db = buildMix rec {
        name = "guardian_db";
        version = "3.0.0";

        src = fetchHex {
          pkg = "guardian_db";
          version = "${version}";
          hash = "sha256-nC7EJ476NPnxzGunleVS1B/cf/ulMZ1n7rUzuJOS0YM=";
        };

        beamDeps = [
          ecto
          ecto_sql
          guardian
          postgrex
        ];
      };

      guardian_phoenix = buildMix rec {
        name = "guardian_phoenix";
        version = "2.0.1";

        src = fetchHex {
          pkg = "guardian_phoenix";
          version = "${version}";
          hash = "sha256-IfQ5JGcVGSsjHyKGgEZdHtX73wFVWko7FxZVMvX5oIw=";
        };

        beamDeps = [
          guardian
          phoenix
        ];
      };

      hackney = buildRebar3 rec {
        name = "hackney";
        version = "1.20.1";

        src = fetchHex {
          pkg = "hackney";
          version = "${version}";
          hash = "sha256-/pCU5fGiosCn0QkY/uNr/sDsKpeZlM/4z+gFjNmvOOM=";
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

      hammer = buildMix rec {
        name = "hammer";
        version = "6.2.1";

        src = fetchHex {
          pkg = "hammer";
          version = "${version}";
          hash = "sha256-uUdtDBOIPS3AzHLnhrrGrCiRH7p8wuBLcM5qbZxLK9w=";
        };

        beamDeps = [ poolboy ];
      };

      haversine = buildMix rec {
        name = "haversine";
        version = "0.1.0";

        src = fetchHex {
          pkg = "haversine";
          version = "${version}";
          hash = "sha256-VNxI6JW8GKWUN6NwJshzY04XtkimTLh7+vuW9k1gcGA=";
        };

        beamDeps = [ ];
      };

      hpax = buildMix rec {
        name = "hpax";
        version = "0.1.2";

        src = fetchHex {
          pkg = "hpax";
          version = "${version}";
          hash = "sha256-LIeEPVoj9fFnSOvneWmIDimAlYDv2szWFc077WKKjBM=";
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

      ip_reserved = buildMix rec {
        name = "ip_reserved";
        version = "0.1.1";

        src = fetchHex {
          pkg = "ip_reserved";
          version = "${version}";
          hash = "sha256-VfzStuIRyu8J6j9U7zfUMDC+xIYyXRL+hlq17YFApP4=";
        };

        beamDeps = [ inet_cidr ];
      };

      jason = buildMix rec {
        name = "jason";
        version = "1.4.1";

        src = fetchHex {
          pkg = "jason";
          version = "${version}";
          hash = "sha256-+7Aezf1WW1YmEwL34fzCfE+48y1W6rdNtiH8FUYEp6E=";
        };

        beamDeps = [ decimal ];
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

      junit_formatter = buildMix rec {
        name = "junit_formatter";
        version = "3.3.1";

        src = fetchHex {
          pkg = "junit_formatter";
          version = "${version}";
          hash = "sha256-dh/FvktMFdi6kaba/eCywq5tudp7iDKlW1od61JNpys=";
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

      makeup = buildMix rec {
        name = "makeup";
        version = "1.1.1";

        src = fetchHex {
          pkg = "makeup";
          version = "${version}";
          hash = "sha256-XcYvvdDeRN4ZSJi2cQaSSQvnS6oC2dEIvCnwB3g7C0g=";
        };

        beamDeps = [ nimble_parsec ];
      };

      makeup_elixir = buildMix rec {
        name = "makeup_elixir";
        version = "0.16.1";

        src = fetchHex {
          pkg = "makeup_elixir";
          version = "${version}";
          hash = "sha256-4SejQa0bIJvYD3vRYgoVaTqZCO14DDt2O8z30gDHZ8Y=";
        };

        beamDeps = [
          makeup
          nimble_parsec
        ];
      };

      makeup_erlang = buildMix rec {
        name = "makeup_erlang";
        version = "0.1.5";

        src = fetchHex {
          pkg = "makeup_erlang";
          version = "${version}";
          hash = "sha256-lNLphkKFhaIVFtfXFJeBSAATxW4wxqIzU0vt84hnpZo=";
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
        version = "2.0.5";

        src = fetchHex {
          pkg = "mime";
          version = "${version}";
          hash = "sha256-2g1ko2XEW8mTXMXIp/xeSaDg+ZMqdhxV1sUrFCeAoFw=";
        };

        beamDeps = [ ];
      };

      mimerl = buildRebar3 rec {
        name = "mimerl";
        version = "1.2.0";

        src = fetchHex {
          pkg = "mimerl";
          version = "${version}";
          hash = "sha256-8nhYVlCqWBmGJkY46/aY+LsZ3yl/Zq2RsYkQ38bhkyM=";
        };

        beamDeps = [ ];
      };

      mimetype_parser = buildMix rec {
        name = "mimetype_parser";
        version = "0.1.3";

        src = fetchHex {
          pkg = "mimetype_parser";
          version = "${version}";
          hash = "sha256-fY+AxWeAfOeM2TyTjn9LCiCxqqqrkUvyhvaEV9n3qFI=";
        };

        beamDeps = [ ];
      };

      mix_test_watch = buildMix rec {
        name = "mix_test_watch";
        version = "1.1.2";

        src = fetchHex {
          pkg = "mix_test_watch";
          version = "${version}";
          hash = "sha256-jOefxpowTuyBq2waBd4usCaolZ9l+0f5M86OtWAYujU=";
        };

        beamDeps = [ file_system ];
      };

      mmdb2_decoder = buildMix rec {
        name = "mmdb2_decoder";
        version = "3.0.1";

        src = fetchHex {
          pkg = "mmdb2_decoder";
          version = "${version}";
          hash = "sha256-MWrw84j6yCR4LZRPVO/njnyWkbu9sK/VzM3QUQrfVZ0=";
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

      nimble_csv = buildMix rec {
        name = "nimble_csv";
        version = "1.2.0";

        src = fetchHex {
          pkg = "nimble_csv";
          version = "${version}";
          hash = "sha256-0GKBF/zCFIF4sDQETFU1myaWbG6qjizhV3e+O7yRsSo=";
        };

        beamDeps = [ ];
      };

      nimble_parsec = buildMix rec {
        name = "nimble_parsec";
        version = "1.4.0";

        src = fetchHex {
          pkg = "nimble_parsec";
          version = "${version}";
          hash = "sha256-nFZYYoEPs4Ppg4wd0tfSxDez0TsmdBS6avM+UNLRzyg=";
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

      oauth2 = buildMix rec {
        name = "oauth2";
        version = "2.1.0";

        src = fetchHex {
          pkg = "oauth2";
          version = "${version}";
          hash = "sha256-isB/hbMwfdGs/rDshS9kFhsi9X0M4MFeYWod/I6+K0E=";
        };

        beamDeps = [ tesla ];
      };

      oauther = buildMix rec {
        name = "oauther";
        version = "1.3.0";

        src = fetchHex {
          pkg = "oauther";
          version = "${version}";
          hash = "sha256-eOuIjqh1xyyiewhkpvVQvG7oTy7so3sJPT2DP7yuwE4=";
        };

        beamDeps = [ ];
      };

      oban = buildMix rec {
        name = "oban";
        version = "2.17.5";

        src = fetchHex {
          pkg = "oban";
          version = "${version}";
          hash = "sha256-/TzLv9uyvHcQfIeQlG+YIagx7QcgaISF7mrc14Y4hs8=";
        };

        beamDeps = [
          ecto_sql
          jason
          postgrex
          telemetry
        ];
      };

      paasaa = buildMix rec {
        name = "paasaa";
        version = "0.6.0";

        src = fetchHex {
          pkg = "paasaa";
          version = "${version}";
          hash = "sha256-cy3fwhusCDHtsmrsRorz7CuJl9dPYgmBCxzFMZnCny4=";
        };

        beamDeps = [ ];
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

      phoenix = buildMix rec {
        name = "phoenix";
        version = "1.7.11";

        src = fetchHex {
          pkg = "phoenix";
          version = "${version}";
          hash = "sha256-sexX8uQDFrMGcI/lm5Kha59vS/UMz6QaqMf+t54OwCo=";
        };

        beamDeps = [
          castore
          jason
          phoenix_pubsub
          phoenix_template
          phoenix_view
          plug
          plug_crypto
          telemetry
          websock_adapter
        ];
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
        version = "3.3.3";

        src = fetchHex {
          pkg = "phoenix_html";
          version = "${version}";
          hash = "sha256-kj6+b+xuLjs+Vp373GVg3pMs1UsACtoCCLX0UCS912w=";
        };

        beamDeps = [ plug ];
      };

      phoenix_live_reload = buildMix rec {
        name = "phoenix_live_reload";
        version = "1.4.1";

        src = fetchHex {
          pkg = "phoenix_live_reload";
          version = "${version}";
          hash = "sha256-m/+4NOfd8IRn/lSuWLV4VQequmJVVoriK01G4rs2Fas=";
        };

        beamDeps = [
          file_system
          phoenix
        ];
      };

      phoenix_live_view = buildMix rec {
        name = "phoenix_live_view";
        version = "0.20.10";

        src = fetchHex {
          pkg = "phoenix_live_view";
          version = "${version}";
          hash = "sha256-2qF7P739Y0eqreTbAaXdJNI68PQ0Ti4kk06K37ShFgc=";
        };

        beamDeps = [
          jason
          phoenix
          phoenix_html
          phoenix_template
          phoenix_view
          plug
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
        version = "2.0.3";

        src = fetchHex {
          pkg = "phoenix_view";
          version = "${version}";
          hash = "sha256-zTQEmvQb4sYn35nNTqpx/FKjKMDD2OfUqij4gMMOf2Q=";
        };

        beamDeps = [
          phoenix_html
          phoenix_template
        ];
      };

      plug = buildMix rec {
        name = "plug";
        version = "1.15.3";

        src = fetchHex {
          pkg = "plug";
          version = "${version}";
          hash = "sha256-zENlo8AQpWr0AuCAkgiHPRE+nDjEAcq9iAJ+9PXAH9I=";
        };

        beamDeps = [
          mime
          plug_crypto
          telemetry
        ];
      };

      plug_crypto = buildMix rec {
        name = "plug_crypto";
        version = "2.0.0";

        src = fetchHex {
          pkg = "plug_crypto";
          version = "${version}";
          hash = "sha256-U2lbrlfMTlRWbZk+sBB05NiUtlo3ZvHEPixhobD0Xqk=";
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
        version = "0.17.4";

        src = fetchHex {
          pkg = "postgrex";
          version = "${version}";
          hash = "sha256-ZFj31bcGUryBw+p1n5FzbBajG+AA8wbTxkvN/poYs8w=";
        };

        beamDeps = [
          db_connection
          decimal
          jason
        ];
      };

      progress_bar = buildMix rec {
        name = "progress_bar";
        version = "3.0.0";

        src = fetchHex {
          pkg = "progress_bar";
          version = "${version}";
          hash = "sha256-aYHCslqySuzJGi3EZiNljhOZwhoq4k25hrkNZ4Uw8rc=";
        };

        beamDeps = [ decimal ];
      };

      ranch = buildRebar3 rec {
        name = "ranch";
        version = "2.1.0";

        src = fetchHex {
          pkg = "ranch";
          version = "${version}";
          hash = "sha256-JE7j+iphdScNjh/FkCT9nbx2KUoyEFfej4A7FHnnaRY=";
        };

        beamDeps = [ ];
      };

      remote_ip = buildMix rec {
        name = "remote_ip";
        version = "1.1.0";

        src = fetchHex {
          pkg = "remote_ip";
          version = "${version}";
          hash = "sha256-YW/99mqq1qcvxUbav0Lu2H4qmel7CcvZKxDMGA0C7XQ=";
        };

        beamDeps = [
          combine
          plug
        ];
      };

      replug = buildMix rec {
        name = "replug";
        version = "0.1.0";

        src = fetchHex {
          pkg = "replug";
          version = "${version}";
          hash = "sha256-9x96V+lE6FT+SUYGDGlkCY5TlYB0xp+4RLluC9WM+mA=";
        };

        beamDeps = [ plug ];
      };

      sentry = buildMix rec {
        name = "sentry";
        version = "8.1.0";

        src = fetchHex {
          pkg = "sentry";
          version = "${version}";
          hash = "sha256-+fx2Qe9h6IVRD15ZY8KUi53h3ll8Y/eB6dPWychoGrQ=";
        };

        beamDeps = [
          hackney
          jason
          plug
        ];
      };

      shortuuid = buildMix rec {
        name = "shortuuid";
        version = "3.0.0";

        src = fetchHex {
          pkg = "shortuuid";
          version = "${version}";
          hash = "sha256-39j4D1FMu5FiLLg/SsDW4vBtmMxtSuupRESiEiidDTk=";
        };

        beamDeps = [ ];
      };

      sitemapper = buildMix rec {
        name = "sitemapper";
        version = "0.8.0";

        src = fetchHex {
          pkg = "sitemapper";
          version = "${version}";
          hash = "sha256-fNQrRUA12kVxUcm2oxS2iLW75Tg63ZW63GXQE8JZicU=";
        };

        beamDeps = [ xml_builder ];
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

      slugger = buildMix rec {
        name = "slugger";
        version = "0.3.0";

        src = fetchHex {
          pkg = "slugger";
          version = "${version}";
          hash = "sha256-INDe0OcSYF0ermxbSIlYHDRg2SYjqTDd2pHg5gm1r7o=";
        };

        beamDeps = [ ];
      };

      slugify = buildMix rec {
        name = "slugify";
        version = "1.3.1";

        src = fetchHex {
          pkg = "slugify";
          version = "${version}";
          hash = "sha256-ywkLvrBWsxLaMSXmgdmJM6Ngpw0yeCDkt/kWRcTYvnY=";
        };

        beamDeps = [ ];
      };

      sobelow = buildMix rec {
        name = "sobelow";
        version = "0.13.0";

        src = fetchHex {
          pkg = "sobelow";
          version = "${version}";
          hash = "sha256-zW6QJrhfw111KdoU+V6FoHjZ3RkHqQl7O6asfrvjSg0=";
        };

        beamDeps = [ jason ];
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

      struct_access = buildMix rec {
        name = "struct_access";
        version = "1.1.2";

        src = fetchHex {
          pkg = "struct_access";
          version = "${version}";
          hash = "sha256-5MQR3MAiYIG5VwmQlVH8krj+saNHYQg0jqfj9sEuWGo=";
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
        version = "1.15.3";

        src = fetchHex {
          pkg = "swoosh";
          version = "${version}";
          hash = "sha256-l6ZnuWyozEikZ59s0fQKNthwHPBSWHKYRzYUyqcPFko=";
        };

        beamDeps = [
          bandit
          gen_smtp
          hackney
          jason
          mime
          plug
          telemetry
        ];
      };

      telemetry = buildRebar3 rec {
        name = "telemetry";
        version = "1.2.1";

        src = fetchHex {
          pkg = "telemetry";
          version = "${version}";
          hash = "sha256-2tnOnY7/xiFwj5nqxTjvHL4F1qh03XQd4uaJxH/q/tU=";
        };

        beamDeps = [ ];
      };

      tesla = buildMix rec {
        name = "tesla";
        version = "1.8.0";

        src = fetchHex {
          pkg = "tesla";
          version = "${version}";
          hash = "sha256-EFAfNgzZJqMJUBKHRwNyrxpuHL7Q9DlJIDpMEzALx58=";
        };

        beamDeps = [
          castore
          hackney
          jason
          mime
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
        version = "3.7.11";

        src = fetchHex {
          pkg = "timex";
          version = "${version}";
          hash = "sha256-i5Ak9++6uvm9eqBPZc+NzXyYGMpXN2d8e3asvGqU0ao=";
        };

        beamDeps = [
          combine
          gettext
          tzdata
        ];
      };

      tls_certificate_check = buildRebar3 rec {
        name = "tls_certificate_check";
        version = "1.21.0";

        src = fetchHex {
          pkg = "tls_certificate_check";
          version = "${version}";
          hash = "sha256-bO5s/8NaOQhA1I1GNUHVB0ansOQhrKrbgzz8eWHkkOc=";
        };

        beamDeps = [ ssl_verify_fun ];
      };

      tz_world = buildMix rec {
        name = "tz_world";
        version = "1.3.2";

        src = fetchHex {
          pkg = "tz_world";
          version = "${version}";
          hash = "sha256-0aNF4HszeMTJAq1U+9XVTIw91V26iDt0B/5XvOxF/yo=";
        };

        beamDeps = [
          castore
          certifi
          geo
          jason
        ];
      };

      tzdata = buildMix rec {
        name = "tzdata";
        version = "1.1.1";

        src = fetchHex {
          pkg = "tzdata";
          version = "${version}";
          hash = "sha256-ppzsg1Lq/NLhmN6iijQRO2D9xstX61rWXBApKmuol4c=";
        };

        beamDeps = [ hackney ];
      };

      ueberauth = buildMix rec {
        name = "ueberauth";
        version = "0.10.8";

        src = fetchHex {
          pkg = "ueberauth";
          version = "${version}";
          hash = "sha256-8tMXLlKCE3W8y4Rg5fpcuRz9YLGbY2tuV+l1m2+MEME=";
        };

        beamDeps = [ plug ];
      };

      ueberauth_cas = buildMix rec {
        name = "ueberauth_cas";
        version = "2.3.1";

        src = fetchHex {
          pkg = "ueberauth_cas";
          version = "${version}";
          hash = "sha256-UGiuK54hfC8FqppnSDplMeIboL6ab2yHSbt/0Vmb4yE=";
        };

        beamDeps = [
          httpoison
          sweet_xml
          ueberauth
        ];
      };

      ueberauth_discord = buildMix rec {
        name = "ueberauth_discord";
        version = "0.7.0";

        src = fetchHex {
          pkg = "ueberauth_discord";
          version = "${version}";
          hash = "sha256-1vmO+Rq7Tdzq2kt6y6Rw4OaMTS3pc1/y8kFyqOGYlrQ=";
        };

        beamDeps = [
          oauth2
          ueberauth
        ];
      };

      ueberauth_facebook = buildMix rec {
        name = "ueberauth_facebook";
        version = "0.10.0";

        src = fetchHex {
          pkg = "ueberauth_facebook";
          version = "${version}";
          hash = "sha256-v4zl1mscUNqKv/d+gIbBtxC93mP0rK7xmmUbpDqVN6g=";
        };

        beamDeps = [
          oauth2
          ueberauth
        ];
      };

      ueberauth_github = buildMix rec {
        name = "ueberauth_github";
        version = "0.8.3";

        src = fetchHex {
          pkg = "ueberauth_github";
          version = "${version}";
          hash = "sha256-rgqyh5wyz6UdcoekghmyYr/asLfsZinyQWBWQkdJPMY=";
        };

        beamDeps = [
          oauth2
          ueberauth
        ];
      };

      ueberauth_gitlab_strategy = buildMix rec {
        name = "ueberauth_gitlab_strategy";
        version = "0.4.0";

        src = fetchHex {
          pkg = "ueberauth_gitlab_strategy";
          version = "${version}";
          hash = "sha256-6G4ueUuwY8B8BaaxMBtz8r47qTCNj0fsxNUQ75ImCR4=";
        };

        beamDeps = [
          oauth2
          ueberauth
        ];
      };

      ueberauth_google = buildMix rec {
        name = "ueberauth_google";
        version = "0.12.1";

        src = fetchHex {
          pkg = "ueberauth_google";
          version = "${version}";
          hash = "sha256-f33qzWebK2bjv/to7Md6obU5agy6wpQYFfJTEo5FjDg=";
        };

        beamDeps = [
          oauth2
          ueberauth
        ];
      };

      ueberauth_keycloak_strategy = buildMix rec {
        name = "ueberauth_keycloak_strategy";
        version = "0.4.0";

        src = fetchHex {
          pkg = "ueberauth_keycloak_strategy";
          version = "${version}";
          hash = "sha256-wDAnk3vdy9n/SZ5Ff5uwX3kBj6Mhq/eevP7SrwAHIRs=";
        };

        beamDeps = [
          oauth2
          ueberauth
        ];
      };

      ueberauth_twitter = buildMix rec {
        name = "ueberauth_twitter";
        version = "0.4.1";

        src = fetchHex {
          pkg = "ueberauth_twitter";
          version = "${version}";
          hash = "sha256-g8qOo+Gj+Xbxrb6/syO56/U69FP7v1fQSGgBowOxYGU=";
        };

        beamDeps = [
          httpoison
          oauther
          ueberauth
        ];
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

      unplug = buildMix rec {
        name = "unplug";
        version = "1.0.0";

        src = fetchHex {
          pkg = "unplug";
          version = "${version}";
          hash = "sha256-0XGoV1iqQS1OhbgJwgPhscTHak1qtY5o3JqKis2bfDo=";
        };

        beamDeps = [ plug ];
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

      vite_phx = buildMix rec {
        name = "vite_phx";
        version = "0.3.1";

        src = fetchHex {
          pkg = "vite_phx";
          version = "${version}";
          hash = "sha256-CLFyYJShMUkP8KLHdkxM3Utc34updiY4pd1LzZ5fyTY=";
        };

        beamDeps = [
          jason
          phoenix
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
        version = "0.5.5";

        src = fetchHex {
          pkg = "websock_adapter";
          version = "${version}";
          hash = "sha256-S5d7pKAZGKy/dwRf+I3n9pcsKgCSE8UVpEXEjyJP/Ok=";
        };

        beamDeps = [
          bandit
          plug
          websock
        ];
      };

      xml_builder = buildMix rec {
        name = "xml_builder";
        version = "2.2.0";

        src = fetchHex {
          pkg = "xml_builder";
          version = "${version}";
          hash = "sha256-nWbVL7kXVl01gWakMUB4057wTVUpBN6W+Oc/aPZKYsk=";
        };

        beamDeps = [ ];
      };
    };
in
self
