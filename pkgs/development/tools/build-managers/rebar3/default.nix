{ lib, stdenv, fetchFromGitHub,
  fetchHex, erlang,
  tree }:

let
  version = "3.14.4";

  # Dependencies should match the ones in:
  # https://github.com/erlang/rebar3/blob/${version}/rebar.lock
  # `sha256` could also be taken from https://hex.pm - Checksum

  bbmustache = fetchHex {
    pkg = "bbmustache";
    version = "1.10.0";
    sha256 = "1vp27jqnq65a8iqp7j4z8nw9ad29dhky5agmg8aj75dvshzzmvs3";
  };
  certifi = fetchHex {
    pkg = "certifi";
    version = "2.5.3";
    sha256 = "040w1scglvqhcvc1ifdnlcyrbwr0smi00w4xi8h03c99775nllgd";
  };
  cf = fetchHex {
    pkg = "cf";
    version = "0.3.1";
    sha256 = "0wknz4xkqkhgvlx4vx5619p8m65v7g87lfgsvfy04jrsgm28spii";
  };
  cth_readable = fetchHex {
    pkg = "cth_readable";
    version = "1.5.0";
    sha256 = "0z58b6frqdnhyzrmbdf6x78l3izbbh5z5i3am8hqc253r7xwv0dx";
  };
  erlware_commons = fetchHex {
    pkg = "erlware_commons";
    version = "1.4.0";
    sha256 = "1rp2vkgzqm6sax7fc13rh9x6qzxsgg718dnv7l0kmarvyifcyphq";
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
    version = "3.3.1";
    sha256 = "12w8ai6b5s6b4hnvkav7hwxd846zdd74r32f84nkcmjzi1vrbk87";
  };

  providers = fetchHex {
    pkg = "providers";
    version = "1.8.1";
    sha256 = "183b9128l4af60rs40agqh6kc6db33j4027ad6jajxn4x6nlamz4";
  };

  relx = fetchHex {
    pkg = "relx";
    version = "4.3.0";
    sha256 = "0h044arh41sr92r1nlg176shavlv7pvw17alwklhszgwlr4hk3kk";
  };

  ssl_verify_fun = fetchHex {
    pkg = "ssl_verify_fun";
    version = "1.1.6";
    sha256 = "1026l1z1jh25z8bfrhaw0ryk5gprhrpnirq877zqhg253x3x5c5x";
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
    sha256 = "09bnqwli93sq1pcz4h88ks7qg7k8yrjy9fd46yyp8xdl7i4irwy2";
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
