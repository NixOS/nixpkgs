{ lib
, beamPackages
, fetchFromGitea, fetchFromGitHub, fetchFromGitLab
, cmake, file, libxcrypt
, writeText
, nixosTests
, ...
}:

beamPackages.mixRelease rec {
  pname = "pleroma";
  version = "3.5.0";

  src = fetchFromGitea {
    domain = "akkoma.dev";
    owner = "AkkomaGang";
    repo = "akkoma";
    rev = "v${version}";
    hash = "sha256-Apt+6nI4zOCyRb5msPt5UF9vyaendyaOjrYBMl0DqRY=";
  };

  postPatch = ''
    # Remove dependency on OS_Mon
    sed -E -i 's/(^|\s):os_mon,//' \
      mix.exs
  '';

  postBuild = ''
    # Digest and compress static files
    rm -f priv/static/READ_THIS_BEFORE_TOUCHING_FILES_HERE
    mix phx.digest --no-deps-check
  '';

  # cf. https://github.com/whitfin/cachex/issues/205
  stripDebug = false;

  mixNixDeps = import ./mix.nix {
    inherit beamPackages lib;
    overrides = (final: prev: {
      # mix2nix does not support git dependencies yet,
      # so we need to add them manually
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

        buildInputs = [ libxcrypt ];

        postInstall = ''
          mv $out/lib/erlang/lib/crypt-${version}/priv/{source,crypt}.so
        '';

        beamDeps = with final; [ elixir_make ];
      };
      elasticsearch = beamPackages.buildMix rec {
        name = "elasticsearch";
        version = "1.0.1";

        src = fetchFromGitea {
          domain = "akkoma.dev";
          owner = "AkkomaGang";
          repo = "elasticsearch-elixir";
          rev = "6cd946f75f6ab9042521a009d1d32d29a90113ca";
          hash = "sha256-CtmQHVl+VTpemne+nxbkYGcErrgCo+t3ZBPbkFSpyF0=";
        };
      };
      gettext = beamPackages.buildMix {
        name = "gettext";
        version = "0.19.1";

        src = fetchFromGitHub {
          owner = "tusooa";
          repo = "gettext";
          rev = "72fb2496b6c5280ed911bdc3756890e7f38a4808";
          hash = "sha256-V0qmE+LcAbVoWsJmWE4fwrduYFIZ5BzK/sGzgLY3eH0=";
        };
      };
      linkify = beamPackages.buildMix rec {
        name = "linkify";
        version = "0.5.2";

        src = fetchFromGitea {
          domain = "akkoma.dev";
          owner = "AkkomaGang";
          repo = "linkify";
          rev = "2567e2c1073fa371fd26fd66dfa5bc77b6919c16";
          hash = "sha256-e3wzlbRuyw/UB5Tb7IozX/WR1T+sIBf9C/o5Thki9vg=";
        };
      };
      mfm_parser = beamPackages.buildMix rec {
        name = "mfm_parser";
        version = "0.1.1";

        src = fetchFromGitea {
          domain = "akkoma.dev";
          owner = "AkkomaGang";
          repo = "mfm-parser";
          rev = "912fba81152d4d572e457fd5427f9875b2bc3dbe";
          hash = "sha256-n3WmERxKK8VM8jFIBAPS6GkbT7/zjqi3AjjWbjOdMzs=";
        };

        beamDeps = with final; [ phoenix_view temple ];
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
      search_parser = beamPackages.buildMix rec {
        name = "search_parser";
        version = "0.1.0";

        src = fetchFromGitHub {
          owner = "FloatingGhost";
          repo = "pleroma-contrib-search-parser";
          rev = "08971a81e68686f9ac465cfb6661d51c5e4e1e7f";
          hash = "sha256-sbo9Kcp2oT05o2GAF+IgziLPYmCkWgBfFMBCytmqg3Y=";
        };

        beamDeps = with final; [ nimble_parsec ];
      };
      temple = beamPackages.buildMix rec {
        name = "temple";
        version = "0.9.0-rc.0";

        src = fetchFromGitea {
          domain = "akkoma.dev";
          owner = "AkkomaGang";
          repo = "temple";
          rev = "066a699ade472d8fa42a9d730b29a61af9bc8b59";
          hash = "sha256-qA0z8WTMjO2OixcZBARn/LbuV3s3LGtwZ9nSjj/tWBc=";
        };

        mixEnv = "dev";
        beamDeps = with final; [ earmark_parser ex_doc makeup makeup_elixir makeup_erlang nimble_parsec ];
      };


      # Some additional build inputs and build fixes
      fast_html = prev.fast_html.override {
        nativeBuildInputs = [ cmake ];
        dontUseCmakeConfigure = true;
      };
      http_signatures = prev.http_signatures.override {
        patchPhase = ''
          substituteInPlace mix.exs --replace ":logger" ":logger, :public_key"
        '';
      };
      majic = prev.majic.override {
        buildInputs = [ file ];
      };
      syslog = prev.syslog.override {
        buildPlugins = with beamPackages; [ pc ];
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
    tests = with nixosTests; { inherit akkoma akkoma-confined; };
    inherit mixNixDeps;
  };

  meta = with lib; {
    description = "ActivityPub microblogging server";
    homepage = "https://akkoma.social";
    license = licenses.agpl3;
    maintainers = with maintainers; [ mvs ];
    platforms = platforms.unix;
  };
}
