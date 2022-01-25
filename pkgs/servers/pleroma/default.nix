{ lib, beamPackages
, fetchFromGitHub, fetchFromGitLab
, file, cmake
, nixosTests, writeText
, ...
}:

beamPackages.mixRelease rec {
  pname = "pleroma";
  version = "2.4.2";

  src = fetchFromGitLab {
    domain = "git.pleroma.social";
    owner = "pleroma";
    repo = "pleroma";
    rev = "v${version}";
    sha256 = "sha256-RcqqNNNCR4cxETUCyjChkpq+cQ1QzNOHHzdqBLtOc6g=";
  };

  mixNixDeps = import ./mix.nix {
    inherit beamPackages lib;
    overrides = (final: prev: {
      # mix2nix does not support git dependencies yet,
      # so we need to add them manually
      prometheus_ex = beamPackages.buildMix rec {
        name = "prometheus_ex";
        version = "3.0.5";

        src = fetchFromGitLab {
          domain = "git.pleroma.social";
          group = "pleroma";
          owner = "elixir-libraries";
          repo = "prometheus.ex";
          rev = "a4e9beb3c1c479d14b352fd9d6dd7b1f6d7deee5";
          sha256 = "1v0q4bi7sb253i8q016l7gwlv5562wk5zy3l2sa446csvsacnpjk";
        };
        beamDeps = with final; [ prometheus ];
      };
      captcha = beamPackages.buildMix rec {
        name = "captcha";
        version = "0.1.0";

        src = fetchFromGitLab {
          domain = "git.pleroma.social";
          group = "pleroma";
          owner = "elixir-libraries";
          repo = "elixir-captcha";
          rev = "e0f16822d578866e186a0974d65ad58cddc1e2ab";
          sha256 = "0qbf86l59kmpf1nd82v4141ba9ba75xwmnqzpgbm23fa1hh8pi9c";
        };
        beamDeps = with final; [ ];
      };
      remote_ip = beamPackages.buildMix rec {
        name = "remote_ip";
        version = "0.1.5";

        src = fetchFromGitLab {
          domain = "git.pleroma.social";
          group = "pleroma";
          owner = "elixir-libraries";
          repo = "remote_ip";
          rev = "b647d0deecaa3acb140854fe4bda5b7e1dc6d1c8";
          sha256 = "0c7vmakcxlcs3j040018i7bfd6z0yq6fjfig02g5fgakx398s0x6";
        };
        beamDeps = with final; [ combine plug inet_cidr ];
      };
      concurrent_limiter = beamPackages.buildMix rec {
        name = "concurrent_limiter";
        version = "0.1.0";

        src = fetchFromGitLab {
          domain = "git.pleroma.social";
          group = "pleroma";
          owner = "elixir-libraries";
          repo = "concurrent_limiter";
          rev = "d81be41024569330f296fc472e24198d7499ba78";
          sha256 = "1nci8zz1gy7dnvxf5ydjqbagf4g9f7z5x1v9kdyy7jz9f37z6qw9";
        };
        beamDeps = with final; [ telemetry ];
      };
      prometheus_phx = beamPackages.buildMix rec {
        name = "prometheus_phx";
        version = "0.1.1";

        preBuild = ''
          touch config/prod.exs
       '';
        src = fetchFromGitLab {
          domain = "git.pleroma.social";
          group = "pleroma";
          owner = "elixir-libraries";
          repo = "prometheus-phx";
          rev = "9cd8f248c9381ffedc799905050abce194a97514";
          sha256 = "0211z4bxb0bc0zcrhnph9kbbvvi1f2v95madpr96pqzr60y21cam";
        };
        beamDeps = with final; [ prometheus_ex ];
      };
      majic = beamPackages.buildMix rec {
        name = "majic";
        version = "1.0.0";

        src = fetchFromGitLab {
          domain = "git.pleroma.social";
          group = "pleroma";
          owner = "elixir-libraries";
          repo = "majic";
          rev = "289cda1b6d0d70ccb2ba508a2b0bd24638db2880";
          sha256 = "15605lsdd74bmsp5z96f76ihn7m2g3p1hjbhs2x7v7309n1k108n";
        };
        patchPhase = ''
          substituteInPlace lib/majic/server.ex --replace "erlang.now" "erlang.time"
        '';
        buildInputs = [ file ];

        beamDeps = with final; [ nimble_pool mime plug elixir_make ];
      };
      crypt = beamPackages.buildRebar3 rec {
        name = "crypt";
        version = "0.4.3";

        src = fetchFromGitHub {
          owner = "msantos";
          repo = "crypt";
          rev = "f75cd55325e33cbea198fb41fe41871392f8fb76";
          sha256 = "sha256-ZYhZTe7cTITkl8DZ4z2IOlxTX5gnbJImu/lVJ2ZjR1o=";
        };

        postInstall = "mv $out/lib/erlang/lib/crypt-${version}/priv/{source,crypt}.so";

        beamDeps = with final; [ elixir_make ];
      };
      web_push_encryption = beamPackages.buildMix rec {
        name = "web_push_encryption";
        version = "0.3.0";
        src = fetchFromGitHub {
          owner = "lanodan";
          repo = "elixir-web-push-encryption";
          rev = "026a043037a89db4da8f07560bc8f9c68bcf0cc0";
          sha256 = "0a4x6njqp8v579bc965c9ipsr1z3klrc0pvgj8x1xf69r77gs6sj";
        };
        beamDeps = with final; [ httpoison jose ];
      };

      # Some additional build inputs and build fixes
      http_signatures = prev.http_signatures.override {
        patchPhase = ''
          substituteInPlace mix.exs --replace ":logger" ":logger, :public_key"
        '';
      };
      fast_html = prev.fast_html.override {
        nativeBuildInputs = [ cmake ];
        dontUseCmakeConfigure = true;
      };
      syslog = prev.syslog.override {
        buildPlugins = with beamPackages; [ pc ];
      };

      # This needs a different version (1.0.14 -> 1.0.18) to build properly with
      # our Erlang/OTP version.
      eimp = beamPackages.buildRebar3 rec {
        name = "eimp";
        version = "1.0.18";

        src = beamPackages.fetchHex {
          pkg = name;
          inherit version;
          sha256 = "0fnx2pm1n2m0zs2skivv43s42hrgpq9i143p9mngw9f3swjqpxvx";
        };

        patchPhase = ''
          echo '{plugins, [pc]}.' >> rebar.config
        '';
        buildPlugins = with beamPackages; [ pc ];

        beamDeps = with final; [ p1_utils ];
      };

      mime = prev.mime.override {
        patchPhase = let
          cfgFile = writeText "config.exs" ''
            use Mix.Config
            config :mime, :types, %{
              "application/activity+json" => ["activity+json"],
              "application/jrd+json" => ["jrd+json"],
              "application/ld+json" => ["activity+json"],
              "application/xml" => ["xml"],
              "application/xrd+xml" => ["xrd+xml"]
            }
          '';
        in ''
          mkdir config
          cp ${cfgFile} config/config.exs
        '';
      };
    });
  };

  passthru = {
    tests.pleroma = nixosTests.pleroma;
    inherit mixNixDeps;
  };

  meta = with lib; {
    description = "ActivityPub microblogging server";
    homepage = "https://git.pleroma.social/pleroma/pleroma";
    license = licenses.agpl3;
    maintainers = with maintainers; [ petabyteboy ninjatrappeur yuka kloenk ];
    platforms = platforms.unix;
  };
}
