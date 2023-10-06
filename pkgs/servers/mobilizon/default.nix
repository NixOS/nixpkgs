{ lib
, callPackage
, writeShellScriptBin
, writeText
, beamPackages
, yarn2nix
, mix2nix
, fetchFromGitLab
, fetchFromGitHub
, fetchgit
, fetchurl
, git
, cmake
, nixosTests
, mobilizon-frontend
}:

let
  inherit (beamPackages) mixRelease buildMix buildRebar3 fetchHex;
  common = callPackage ./common.nix { };
in
mixRelease rec {
  inherit (common) pname version src;

  # See https://github.com/whitfin/cachex/issues/205
  # This circumvents a startup error for now
  stripDebug = false;

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
        ex_cldr = prev.ex_cldr.overrideAttrs (old: rec {
          version = "2.37.2";
          # We have to use the GitHub sources, as it otherwise tries to download
          # the locales at build time.
          src = fetchFromGitHub {
            owner = "elixir-cldr";
            repo = "cldr";
            rev = "v${version}";
            sha256 = "sha256-dDOQzLIi3zjb9xPyR7Baul96i9Mb3CFHUA+AWSexrk4=";
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
        exkismet = buildMix rec {
          name = "exkismet";
          version = "0.0.1";
          src = fetchFromGitHub {
            owner = "tcitworld";
            repo = name;
            rev = "8b5485fde00fafbde20f315bec387a77f7358334";
            sha256 = "sha256-ttgCWoBKU7VTjZJBhZNtqVF4kN7psBr/qOeR65MbTqw=";
          };
          beamDeps = with final; [ httpoison ];
        };
        rajska = buildMix rec {
          name = "rajska";
          version = "0.0.1";
          src = fetchFromGitHub {
            owner = "tcitworld";
            repo = name;
            rev = "0c036448e261e8be6a512581c592fadf48982d84";
            sha256 = "sha256-4pfply1vTAIT2Xvm3kONmrCK05xKfXFvcb8EKoSCXBE=";
          };
          beamDeps = with final; [ httpoison absinthe ];
        };

      });
  };

  preConfigure = ''
    export LANG=C.UTF-8 # fix elixir locale warning
  '';

  # Install the compiled js part
  preBuild =
    ''
      cp -a "${mobilizon-frontend}/libexec/mobilizon/deps/priv/static" ./priv
      chmod 770 -R ./priv
    '';

  postBuild = ''
    mix phx.digest --no-deps-check
  '';

  passthru = {
    tests.smoke-test = nixosTests.mobilizon;
    updateScript = writeShellScriptBin "update.sh" ''
      set -eou pipefail

      SRC=$(nix path-info .#mobilizon.src)
      ${mix2nix}/bin/mix2nix $SRC/mix.lock > pkgs/servers/mobilizon/mix.nix
      cat $SRC/js/package.json > pkgs/servers/mobilizon/package.json
    '';
  };

  meta = with lib; {
    description = "Mobilizon is an online tool to help manage your events, your profiles and your groups";
    homepage = "https://joinmobilizon.org/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ minijackson erictapen ];
  };
}
