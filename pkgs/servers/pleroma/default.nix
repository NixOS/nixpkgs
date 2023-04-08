{ lib, beamPackages
, fetchFromGitHub, fetchFromGitLab, fetchHex
, file, cmake
, libxcrypt-legacy
, nixosTests, writeText
, ...
}:

beamPackages.mixRelease rec {
  pname = "pleroma";
  version = "2.5.1";

  src = fetchFromGitLab {
    domain = "git.pleroma.social";
    owner = "pleroma";
    repo = "pleroma";
    rev = "v${version}";
    sha256 = "sha256-3iG2s7jVEnhq1kLLgtaHnFmLYBO2Xr5M5jjZfSNA9z4=";
  };
  stripDebug = false;

  mixNixDeps = import ./mix.nix {
    inherit beamPackages lib;
    overrides = (final: prev: {
      # mix2nix does not support git dependencies yet,
      # so we need to add them manually
      gettext = beamPackages.buildMix rec {
        name = "gettext";
        version = "0.19.1";

        src = fetchFromGitHub {
          owner = "tusooa";
          repo = "gettext";
          rev = "72fb2496b6c5280ed911bdc3756890e7f38a4808";
          sha256 = "sha256-V0qmE+LcAbVoWsJmWE4fwrduYFIZ5BzK/sGzgLY3eH0=";
        };
      };
      prometheus_ex = beamPackages.buildMix rec {
        name = "prometheus_ex";
        version = "3.0.5";

        src = fetchFromGitHub {
          owner = "lanodan";
          repo = "prometheus.ex";
          rev = "31f7fbe4b71b79ba27efc2a5085746c4011ceb8f";
          sha256 = "sha256-2PZP+YnwnHt69HtIAQvjMBqBbfdbkRSoMzb1AL2Zsyc=";
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

        postInstall = "mv priv/* $out/lib/erlang/lib/${name}-${version}/priv/";
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
      majic = prev.majic.override {
        buildInputs = [ file ];
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
      # Required by eimp
      p1_utils = beamPackages.buildRebar3 rec {
        name = "p1_utils";
        version = "1.0.18";

        src = fetchHex {
          pkg = "${name}";
          version = "${version}";
          sha256 = "120znzz0yw1994nk6v28zql9plgapqpv51n9g6qm6md1f4x7gj0z";
        };

        beamDeps = [];
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

      crypt = let
        version = prev.crypt.version;
      in prev.crypt.override {
        buildInputs = [ libxcrypt-legacy ];
        postInstall = "mv $out/lib/erlang/lib/crypt-${version}/priv/{hex-source-crypt-${version},crypt}.so";
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
    maintainers = with maintainers; [ ninjatrappeur yuka kloenk ];
    platforms = platforms.unix;
  };
}
