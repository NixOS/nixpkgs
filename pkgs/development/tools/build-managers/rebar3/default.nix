{ lib, stdenv, fetchFromGitHub,
  fetchHex, erlang,
  tree }:

let
  version = "3.14.2";

  # Dependencies should match the ones in:
  # https://github.com/erlang/rebar3/blob/${version}/rebar.lock
  # `sha256` could also be taken from https://hex.pm - Checksum

  bbmustache = fetchHex {
    pkg = "bbmustache";
    version = "1.10.0";
    sha256 = "43effa3fd4bb9523157af5a9e2276c493495b8459fc8737144aa186cb13ce2ee";
  };
  certifi = fetchHex {
    pkg = "certifi";
    version = "2.5.2";
    sha256 = "3b3b5f36493004ac3455966991eaf6e768ce9884693d9968055aeeeb1e575040";
  };
  cf = fetchHex {
    pkg = "cf";
    version = "0.3.1";
    sha256 = "315e8d447d3a4b02bcdbfa397ad03bbb988a6e0aa6f44d3add0f4e3c3bf97672";
  };
  cth_readable = fetchHex {
    pkg = "cth_readable";
    version = "1.4.9";
    sha256 = "b4c6ababdb046c5f2fbb3c22f030b4c5a679083956dcdd29c1df0cb30b18da24";
  };
  erlware_commons = fetchHex {
    pkg = "erlware_commons";
    version = "1.3.1";
    sha256 = "7aada93f368d0a0430122e39931b7fb4ac9e94dbf043cdc980ad4330fd9cd166";
  };
  eunit_formatters = fetchHex {
    pkg = "eunit_formatters";
    version = "0.5.0";
    sha256 = "1jb3hzb216r29x2h4pcjwfmx1k81431rgh5v0mp4x5146hhvmj6n";
  };
  getopt = fetchHex {
    pkg = "getopt";
    version = "1.0.1";
    sha256 = "53e1ab83b9ceb65c9672d3e7a35b8092e9bdc9b3ee80721471a161c10c59959c";
  };
  parse_trans = fetchHex {
    pkg = "parse_trans";
    version = "3.3.0";
    sha256 = "17ef63abde837ad30680ea7f857dd9e7ced9476cdd7b0394432af4bfc241b960";
  };
  providers = fetchHex {
    pkg = "providers";
    version = "1.8.1";
    sha256 = "e45745ade9c476a9a469ea0840e418ab19360dc44f01a233304e118a44486ba0";
  };
  relx = fetchHex {
    pkg = "relx";
    version = "4.1.0";
    sha256 = "b94a3f96697a479ee5217a853345e0f4977bdf40d3c040af0d3d80fadad82af4";
  };
  ssl_verify_fun = fetchHex {
    pkg = "ssl_verify_fun";
    version = "1.1.6";
    sha256 = "bdb0d2471f453c88ff3908e7686f86f9be327d065cc1ec16fa4540197ea04680";
  };

  hex_core = fetchHex {
    pkg = "hex_core";
    version = "0.7.1";
    sha256 = "05c60411511b6dc79affcd99a93e67d71e1b9d6abcb28ba75cd4ebc8585b8d02";
  };
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
    sha256 = "02gz6xs8j5rm14r6dndcpdm8q3rl4mcj363gnnx4y5xvvfnv9bfa";
  };

  bootstrapper = ./rebar3-nix-bootstrap;

  buildInputs = [ erlang tree ];

  postPatch = ''
    mkdir -p _checkouts
    mkdir -p _build/default/lib/

    cp --no-preserve=mode -R ${bbmustache} _checkouts/bbmustache
    cp --no-preserve=mode -R ${certifi} _checkouts/certifi
    cp --no-preserve=mode -R ${cf} _checkouts/cf
    cp --no-preserve=mode -R ${cth_readable} _checkouts/cth_readable
    cp --no-preserve=mode -R ${erlware_commons} _checkouts/erlware_commons
    cp --no-preserve=mode -R ${eunit_formatters} _checkouts/eunit_formatters
    cp --no-preserve=mode -R ${getopt} _checkouts/getopt
    cp --no-preserve=mode -R ${parse_trans} _checkouts/parse_trans
    cp --no-preserve=mode -R ${providers} _checkouts/providers
    cp --no-preserve=mode -R ${relx} _checkouts/relx
    cp --no-preserve=mode -R ${ssl_verify_fun} _checkouts/ssl_verify_fun

    cp --no-preserve=mode -R ${hex_core} _checkouts/hex_core

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
    maintainers = with lib.maintainers; [ gleber tazjin ];
    license = lib.licenses.asl20;
  };
}
