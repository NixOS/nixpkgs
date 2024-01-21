{ lib
, callPackage
, writeShellScriptBin
, beamPackages
, mix2nix
, fetchFromGitHub
, git
, cmake
, nixosTests
, mobilizon-frontend
, ...
}:

let
  inherit (beamPackages) mixRelease buildMix;
  common = callPackage ./common.nix { };
in
mixRelease rec {
  inherit (common) pname version src;

  nativeBuildInputs = [ git cmake ];

  mixNixDeps = import ./mix.nix {
    inherit beamPackages lib;
    overrides = (final: prev:
      (lib.mapAttrs
        (_: value: value.override {
          appConfigPath = src + "/config";
        })
        prev) // {
        fast_html = prev.fast_html.override {
          nativeBuildInputs = [ cmake ];
        };
        ex_cldr = prev.ex_cldr.overrideAttrs (old: {
          # We have to use the GitHub sources, as it otherwise tries to download
          # the locales at build time.
          src = fetchFromGitHub {
            owner = "elixir-cldr";
            repo = "cldr";
            rev = "v${old.version}";
            sha256 = assert old.version == "2.37.5";
              "sha256-T5Qvuo+xPwpgBsqHNZYnTCA4loToeBn1LKTMsDcCdYs=";
          };
          postInstall = ''
            cp $src/priv/cldr/locales/* $out/lib/erlang/lib/ex_cldr-${old.version}/priv/cldr/locales/
          '';
        });
        # Upstream issue: https://github.com/bryanjos/geo_postgis/pull/87
        geo_postgis = prev.geo_postgis.overrideAttrs (old: {
          propagatedBuildInputs = old.propagatedBuildInputs ++ [ final.ecto ];
        });

        # The remainder are Git dependencies (and their deps) that are not supported by mix2nix currently.
        web_push_encryption = buildMix rec {
          name = "web_push_encryption";
          version = "0.3.1";
          src = fetchFromGitHub {
            owner = "danhper";
            repo = "elixir-web-push-encryption";
            rev = "70f00d06cbd88c9ac382e0ad2539e54448e9d8da";
            sha256 = "sha256-b4ZMrt/8n2sPUFtCDRTwXS1qWm5VlYdbx8qC0R0boOA=";
          };
          beamDeps = with final; [ httpoison jose ];
        };
        icalendar = buildMix rec {
          name = "icalendar";
          version = "unstable-2022-04-10";
          src = fetchFromGitHub {
            owner = "tcitworld";
            repo = name;
            rev = "1033d922c82a7223db0ec138e2316557b70ff49f";
            sha256 = "sha256-N3bJZznNazLewHS4c2B7LP1lgxd1wev+EWVlQ7rOwfU=";
          };
          beamDeps = with final; [ mix_test_watch ex_doc timex ];
        };
        rajska = buildMix rec {
          name = "rajska";
          version = "1.3.3";
          src = fetchFromGitHub {
            owner = "tcitworld";
            repo = name;
            rev = "0c036448e261e8be6a512581c592fadf48982d84";
            sha256 = "sha256-4pfply1vTAIT2Xvm3kONmrCK05xKfXFvcb8EKoSCXBE=";
          };
          beamDeps = with final; [ ex_doc credo absinthe excoveralls hammer mock ];
        };
        exkismet = buildMix rec {
          name = "exkismet";
          version = "0.0.3";
          src = fetchFromGitHub {
            owner = "tcitworld";
            repo = name;
            rev = "8b5485fde00fafbde20f315bec387a77f7358334";
            sha256 = "sha256-ttgCWoBKU7VTjZJBhZNtqVF4kN7psBr/qOeR65MbTqw=";
          };
          beamDeps = with final; [ httpoison ex_doc credo doctor dialyxir ];
        };

      });
  };

  # Install the compiled js part
  preBuild =
    ''
      cp -a "${mobilizon-frontend}/static" ./priv
      chmod 770 -R ./priv
    '';

  postBuild = ''
    mix phx.digest --no-deps-check
  '';

  passthru = {
    tests.smoke-test = nixosTests.mobilizon;
    updateScript = writeShellScriptBin "update.sh" ''
      set -eou pipefail

      ${mix2nix}/bin/mix2nix '${src}/mix.lock' > pkgs/servers/mobilizon/mix.nix
    '';
    elixirPackage = beamPackages.elixir;
  };

  meta = with lib; {
    description = "Mobilizon is an online tool to help manage your events, your profiles and your groups";
    homepage = "https://joinmobilizon.org/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ minijackson erictapen ];
  };
}
