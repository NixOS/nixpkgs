{ lib, stdenv, fetchFromGitHub,
  fetchHex, erlang,
  tree }:

let
  version = "3.15.1";

  # Dependencies should match the ones in:
  # https://github.com/erlang/rebar3/blob/${version}/rebar.lock
  # `sha256` could also be taken from https://hex.pm - Checksum
  deps = import ./rebar-deps.nix { inherit fetchHex; };
in
stdenv.mkDerivation rec {
  pname = "rebar3";
  inherit version erlang;

  # How to obtain `sha256`:
  # nix-prefetch-url --unpack https://github.com/erlang/rebar3/archive/${version}.tar.gz
  src = fetchFromGitHub {
    owner = "erlang";
    repo = pname;
    rev = version;
    sha256 = "1pcy5m79g0l9l3d8lkbx6cq1w87z1g3sa6wwvgbgraj2v3wkyy5g";
  };

  bootstrapper = ./rebar3-nix-bootstrap;

  buildInputs = [ erlang tree ];

  postPatch = ''
    mkdir -p _checkouts
    mkdir -p _build/default/lib/

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
}
