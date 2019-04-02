{ stdenv, fetchurl,
  fetchHex, erlang,
  tree, hexRegistrySnapshot }:

let
  version = "3.9.1";

  bootstrapper = ./rebar3-nix-bootstrap;

  erlware_commons = fetchHex {
    pkg = "erlware_commons";
    version = "1.3.1";
    sha256 = "7aada93f368d0a0430122e39931b7fb4ac9e94dbf043cdc980ad4330fd9cd166";
  };
  ssl_verify_fun = fetchHex {
    pkg = "ssl_verify_fun";
    version = "1.1.3";
    sha256 = "2e120e6505d6e9ededb2836611dfe2f7028432dc280957998e154307b5ea92fe";
  };
  certifi = fetchHex {
    pkg = "certifi";
    version = "2.3.1";
    sha256 = "e12d667d042c11d130594bae2b0097e63836fe8b1e6d6b2cc48f8bb7a2cf7d68";
  };
  providers = fetchHex {
    pkg = "providers";
    version = "1.7.0";
    sha256 = "8be66129ca85c2fa74efd8737cdaedd31c1c1af51dd2fd601495a6def4cae4a6";
  };
  getopt = fetchHex {
    pkg = "getopt";
    version = "1.0.1";
    sha256 = "53e1ab83b9ceb65c9672d3e7a35b8092e9bdc9b3ee80721471a161c10c59959c";
  };
  bbmustache = fetchHex {
    pkg = "bbmustache";
    version = "1.6.0";
    sha256 = "53e02d296512a57be03a98c91541b34d2ca64930268030b2d12364a0332015df";
  };
  relx = fetchHex {
    pkg = "relx";
    version = "3.28.0";
    sha256 = "8afb871c0a2a27f0063d973903fc64d2207bc705ecc3607462920683d24ac7b5";
  };
  cf = fetchHex {
    pkg = "cf";
    version = "0.2.2";
    sha256 = "08cvy7skn5d2k4manlx5k3anqgjdvajjhc5jwxbaszxw34q3na28";
  };
  cth_readable = fetchHex {
    pkg = "cth_readable";
    version = "1.4.3";
    sha256 = "0wr0hba6ka74s3628jrrd7ynjdh7syxigkh7ildg8fgi20ab88fd";
  };
  eunit_formatters = fetchHex {
    pkg = "eunit_formatters";
    version = "0.5.0";
    sha256 = "1jb3hzb216r29x2h4pcjwfmx1k81431rgh5v0mp4x5146hhvmj6n";
  };
  hex_core = fetchHex {
    pkg = "hex_core";
    version = "0.4.0";
    sha256 = "8ace8c6cfa10df4cb8be876f42f7446890e124203c094cc7b4e7616fb8de5d7f";
  };
  parse_trans = fetchHex {
    pkg = "parse_trans";
    version = "3.3.0";
    sha256 = "17ef63abde837ad30680ea7f857dd9e7ced9476cdd7b0394432af4bfc241b960";
  };

in
stdenv.mkDerivation {
  name = "rebar3-${version}";
  inherit version erlang;

  src = fetchurl {
    url = "https://github.com/rebar/rebar3/archive/${version}.tar.gz";
    sha256 = "1n6287av29ws3bvjxxmw8s2j8avwich4ccisnnrnypfbm1khlcxp";
  };

  inherit bootstrapper;

  buildInputs = [ erlang tree ];

  # TODO: Remove registry snapshot
  propagatedBuildInputs = [ hexRegistrySnapshot ];

  postPatch = ''
    ${erlang}/bin/escript ${bootstrapper} registry-only
    mkdir -p _checkouts
    mkdir -p _build/default/lib/

    cp --no-preserve=mode -R ${erlware_commons} _checkouts/erlware_commons
    cp --no-preserve=mode -R ${providers} _checkouts/providers
    cp --no-preserve=mode -R ${getopt} _checkouts/getopt
    cp --no-preserve=mode -R ${bbmustache} _checkouts/bbmustache
    cp --no-preserve=mode -R ${certifi} _checkouts/certifi
    cp --no-preserve=mode -R ${cf} _checkouts/cf
    cp --no-preserve=mode -R ${cth_readable} _checkouts/cth_readable
    cp --no-preserve=mode -R ${eunit_formatters} _checkouts/eunit_formatters
    cp --no-preserve=mode -R ${relx} _checkouts/relx
    cp --no-preserve=mode -R ${ssl_verify_fun} _checkouts/ssl_verify_fun
    cp --no-preserve=mode -R ${hex_core} _checkouts/hex_core
    cp --no-preserve=mode -R ${parse_trans} _checkouts/parse_trans

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
    homepage = https://github.com/rebar/rebar3;
    description = "rebar 3 is an Erlang build tool that makes it easy to compile and test Erlang applications, port drivers and releases";

    longDescription = ''
      rebar is a self-contained Erlang script, so it's easy to distribute or
      even embed directly in a project. Where possible, rebar uses standard
      Erlang/OTP conventions for project structures, thus minimizing the amount
      of build configuration work. rebar also provides dependency management,
      enabling application writers to easily re-use common libraries from a
      variety of locations (hex.pm, git, hg, and so on).
      '';

    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ gleber tazjin ];
    license = stdenv.lib.licenses.asl20;
  };
}
