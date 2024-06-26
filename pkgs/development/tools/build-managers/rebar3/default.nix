{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchgit,
  fetchHex,
  erlang,
  makeWrapper,
  writeScript,
  common-updater-scripts,
  coreutils,
  git,
  gnused,
  nix,
  rebar3-nix,
}:

let
  version = "3.23.0";
  owner = "erlang";
  deps = import ./rebar-deps.nix { inherit fetchFromGitHub fetchgit fetchHex; };
  rebar3 = stdenv.mkDerivation rec {
    pname = "rebar3";
    inherit version erlang;

    # How to obtain `sha256`:
    # nix-prefetch-url --unpack https://github.com/erlang/rebar3/archive/${version}.tar.gz
    src = fetchFromGitHub {
      inherit owner;
      repo = pname;
      rev = version;
      sha256 = "dLJ1ca7Tlx6Cfk/AyJ0HmAgH9+qRrto/m0GWWUeXNko=";
    };

    buildInputs = [ erlang ];

    postPatch = ''
      mkdir -p _checkouts _build/default/lib/

      ${toString (
        lib.mapAttrsToList (k: v: ''
          cp -R --no-preserve=mode ${v} _checkouts/${k}
        '') deps
      )}

      # Bootstrap script expects the dependencies in _build/default/lib
      # TODO: Make it accept checkouts?
      for i in _checkouts/* ; do
          ln -s $(pwd)/$i $(pwd)/_build/default/lib/
      done
    '';

    buildPhase = ''
      HOME=. escript bootstrap
    '';

    checkPhase = ''
      HOME=. escript ./rebar3 ct
    '';

    doCheck = true;

    installPhase = ''
      mkdir -p $out/bin
      cp rebar3 $out/bin/rebar3
    '';

    meta = {
      homepage = "https://github.com/rebar/rebar3";
      description = "Erlang build tool that makes it easy to compile and test Erlang applications, port drivers and releases";
      mainProgram = "rebar3";

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

    passthru.updateScript = writeScript "update.sh" ''
      #!${stdenv.shell}
      set -ox errexit
      PATH=${
        lib.makeBinPath [
          common-updater-scripts
          coreutils
          git
          gnused
          nix
          (rebar3WithPlugins { globalPlugins = [ rebar3-nix ]; })
        ]
      }
      latest=$(list-git-tags | sed -n '/[\d\.]\+/p' | sort -V | tail -1)
      if [ "$latest" != "${version}" ]; then
        nixpkgs="$(git rev-parse --show-toplevel)"
        nix_path="$nixpkgs/pkgs/development/tools/build-managers/rebar3"
        update-source-version rebar3 "$latest" --version-key=version --print-changes --file="$nix_path/default.nix"
        tmpdir=$(mktemp -d)
        cp -R $(nix-build $nixpkgs --no-out-link -A rebar3.src)/* "$tmpdir"
        (cd "$tmpdir" && rebar3 as test nix lock -o "$nix_path/rebar-deps.nix")
      else
        echo "rebar3 is already up-to-date"
      fi
    '';
  };

  # Alias rebar3 so we can use it as default parameter below
  _rebar3 = rebar3;

  rebar3WithPlugins =
    {
      plugins ? [ ],
      globalPlugins ? [ ],
      rebar3 ? _rebar3,
    }:
    let
      pluginLibDirs = map (p: "${p}/lib/erlang/lib") (lib.unique (plugins ++ globalPlugins));
      globalPluginNames = lib.unique (map (p: p.packageName) globalPlugins);
      rebar3Patched = (
        rebar3.overrideAttrs (old: {

          # skip-plugins.patch is necessary because otherwise rebar3 will always
          # try to fetch plugins if they are not already present in _build.
          #
          # global-deps.patch makes it possible to use REBAR_GLOBAL_PLUGINS to
          # instruct rebar3 to always load a certain plugin. It is necessary since
          # REBAR_GLOBAL_CONFIG_DIR doesn't seem to work for this.
          patches = [
            ./skip-plugins.patch
            ./global-plugins.patch
          ];

          # our patches cause the tests to fail
          doCheck = false;
        })
      );
    in
    stdenv.mkDerivation {
      pname = "rebar3-with-plugins";
      inherit (rebar3) version;
      nativeBuildInputs = [
        erlang
        makeWrapper
      ];
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
        cp ${./rebar_ignore_deps.erl} rebar_ignore_deps.erl
        erlc -o $out/lib/rebar/ebin rebar_ignore_deps.erl
        mkdir -p $out/bin
        makeWrapper ${erlang}/bin/erl $out/bin/rebar3 \
          --set REBAR_GLOBAL_PLUGINS "${toString globalPluginNames} rebar_ignore_deps" \
          --suffix-each ERL_LIBS ":" "$out/lib ${toString pluginLibDirs}" \
          --add-flags "+sbtu +A1 -noshell -boot start_clean -s rebar3 main -extra"
      '';
    };
in
{
  inherit rebar3 rebar3WithPlugins;
}
