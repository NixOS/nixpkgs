{ lib, stdenv, fetchFromGitHub,
  fetchHex, erlang, makeWrapper }:

let
  version = "3.15.1";
  owner = "erlang";
  deps = import ./rebar-deps.nix { inherit fetchHex; };
  rebar3 = stdenv.mkDerivation rec {
    pname = "rebar3";
    inherit version erlang;

    # How to obtain `sha256`:
    # nix-prefetch-url --unpack https://github.com/erlang/rebar3/archive/${version}.tar.gz
    src = fetchFromGitHub {
      inherit owner;
      repo = pname;
      rev = version;
      sha256 = "1pcy5m79g0l9l3d8lkbx6cq1w87z1g3sa6wwvgbgraj2v3wkyy5g";
    };

    bootstrapper = ./rebar3-nix-bootstrap;

    buildInputs = [ erlang ];

    postPatch = ''
      mkdir -p _checkouts _build/default/lib/

      ${toString (lib.mapAttrsToList (k: v: ''
        cp -R --no-preserve=mode ${v} _checkouts/${k}
      '') deps)}

      # Bootstrap script expects the dependencies in _build/default/lib
      # TODO: Make it accept checkouts?
      for i in _checkouts/* ; do
          ln -s $(pwd)/$i $(pwd)/_build/default/lib/
      done
    '';

    buildPhase = ''
      HOME=. escript bootstrap
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp rebar3 $out/bin/rebar3
    '';

    meta = {
      homepage = "https://github.com/rebar/rebar3";
      description = "Erlang build tool that makes it easy to compile and test Erlang applications, port drivers and releases";

      longDescription = ''
        rebar is a self-contained Erlang script, so it's easy to distribute or
        even embed directly in a project. Where possible, rebar uses standard
        Erlang/OTP conventions for project structures, thus minimizing the amount
        of build configuration work. rebar also provides dependency management,
        enabling application writers to easily re-use common libraries from a
        variety of locations (hex.pm, git, hg, and so on).
        '';

      platforms = lib.platforms.unix;
      maintainers = lib.teams.beam.members;
      license = lib.licenses.asl20;
    };

  };
  rebar3WithPlugins = { plugins ? [ ], globalPlugins ? [ ] }:
    let
      pluginLibDirs = map (p: "${p}/lib/erlang/lib") (lib.unique (plugins ++ globalPlugins));
      globalPluginNames = lib.unique (map (p: p.packageName) globalPlugins);
      rebar3Patched = (rebar3.overrideAttrs (old: {

        # skip-plugins.patch is necessary because otherwise rebar3 will always
        # try to fetch plugins if they are not already present in _build.
        #
        # global-deps.patch makes it possible to use REBAR_GLOBAL_PLUGINS to
        # instruct rebar3 to always load a certain plugin. It is necessary since
        # REBAR_GLOBAL_CONFIG_DIR doesn't seem to work for this.
        patches = [ ./skip-plugins.patch ./global-plugins.patch ];
      }));
    in stdenv.mkDerivation {
      pname = "rebar3-with-plugins";
      inherit (rebar3) version bootstrapper;
      nativeBuildInputs = [ erlang makeWrapper ];
      unpackPhase = "true";

      # Here we extract the rebar3 escript (like `rebar3_prv_local_install.erl`) and
      # add plugins to the code path.

      installPhase = ''
        erl -noshell -eval '
          {ok, Escript} = escript:extract("${rebar3Patched}/bin/rebar3", []),
          {archive, Archive} = lists:keyfind(archive, 1, Escript),
          {ok, _} = zip:extract(Archive, [{cwd, "'$out/lib'"}]),
          init:stop(0)
        '
        mkdir -p $out/bin
        makeWrapper ${erlang}/bin/erl $out/bin/rebar3 \
          --set REBAR_GLOBAL_PLUGINS "${toString globalPluginNames}" \
          --suffix-each ERL_LIBS ":" "$out/lib ${toString pluginLibDirs}" \
          --add-flags "+sbtu +A1 -noshell -boot start_clean -s rebar3 main -extra"
      '';
    };
in { inherit rebar3 rebar3WithPlugins; }
