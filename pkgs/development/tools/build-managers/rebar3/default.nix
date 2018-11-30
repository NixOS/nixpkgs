{ stdenv, fetchurl,
  fetchHex, erlang, hermeticRebar3 ? true,
  tree, hexRegistrySnapshot }:

let
  version = "3.6.1";

  bootstrapper = ./rebar3-nix-bootstrap;

  erlware_commons = fetchHex {
    pkg = "erlware_commons";
    version = "1.2.0";
    sha256 = "149kkn9gc9cjgvlmakygq475r63q2rry31s29ax0s425dh37sfl7";
  };
  ssl_verify_fun = fetchHex {
    pkg = "ssl_verify_fun";
    version = "1.1.3";
    sha256 = "1zljxashfhqmiscmf298vhr880ppwbgi2rl3nbnyvsfn0mjhw4if";
  };
  certifi = fetchHex {
    pkg = "certifi";
    version = "2.0.0";
    sha256 = "075v7cvny52jbhnskchd3fp68fxgp7qfvdls0haamcycxrn0dipx";
  };
  providers = fetchHex {
    pkg = "providers";
    version = "1.7.0";
    sha256 = "19p4rbsdx9lm2ihgvlhxyld1q76kxpd7qwyqxxsgmhl5r8ln3rlb";
  };
  getopt = fetchHex {
    pkg = "getopt";
    version = "1.0.1";
    sha256 = "174mb46c2qd1f4a7507fng4vvscjh1ds7rykfab5rdnfp61spqak";
  };
  bbmustache = fetchHex {
    pkg = "bbmustache";
    version = "1.5.0";
    sha256 = "0xg3r4lxhqifrv32nm55b4zmkflacc1s964g15p6y6jfx6v4y1zd";
  };
  relx = fetchHex {
    pkg = "relx";
    version = "3.26.0";
    sha256 = "1f810rb01kdidpa985s321ycg3y4hvqpzbk263n6i1bfnqykkvv9";
  };
  cf = fetchHex {
    pkg = "cf";
    version = "0.2.2";
    sha256 = "08cvy7skn5d2k4manlx5k3anqgjdvajjhc5jwxbaszxw34q3na28";
  };
  cth_readable = fetchHex {
    pkg = "cth_readable";
    version = "1.4.2";
    sha256 = "1pjid4f60pp81ds01rqa6ybksrnzqriw3aibilld1asn9iabxkav";
  };
  eunit_formatters = fetchHex {
    pkg = "eunit_formatters";
    version = "0.5.0";
    sha256 = "1jb3hzb216r29x2h4pcjwfmx1k81431rgh5v0mp4x5146hhvmj6n";
  };
  rebar3_hex = fetchHex {
    pkg = "rebar3_hex";
    version = "4.0.0";
    sha256 = "0k0ykx1lz62r03dpbi2zxsvrxgnr5hj67yky0hjrls09ynk4682v";
  };

in
stdenv.mkDerivation {
  name = "rebar3-${version}";
  inherit version;

  src = fetchurl {
    url = "https://github.com/rebar/rebar3/archive/${version}.tar.gz";
    sha256 = "0cqhqymzh10pfyxqiy4hcg3d2myz3chx0y4m2ixmq8zk81acics0";
  };

  inherit bootstrapper;

  patches = if hermeticRebar3 == true
  then  [ ./hermetic-rebar3.patch ]
  else [];

  buildInputs = [ erlang tree  ];
  propagatedBuildInputs = [ hexRegistrySnapshot ];

  postPatch = ''
    ${erlang}/bin/escript ${bootstrapper} registry-only
    mkdir -p _build/default/lib/
    mkdir -p _build/default/plugins
    cp --no-preserve=mode -R ${erlware_commons} _build/default/lib/erlware_commons
    cp --no-preserve=mode -R ${providers} _build/default/lib/providers
    cp --no-preserve=mode -R ${getopt} _build/default/lib/getopt
    cp --no-preserve=mode -R ${bbmustache} _build/default/lib/bbmustache
    cp --no-preserve=mode -R ${certifi} _build/default/lib/certifi
    cp --no-preserve=mode -R ${cf} _build/default/lib/cf
    cp --no-preserve=mode -R ${cth_readable} _build/default/lib/cth_readable
    cp --no-preserve=mode -R ${eunit_formatters} _build/default/lib/eunit_formatters
    cp --no-preserve=mode -R ${relx} _build/default/lib/relx
    cp --no-preserve=mode -R ${ssl_verify_fun} _build/default/lib/ssl_verify_fun
    cp --no-preserve=mode -R ${rebar3_hex} _build/default/plugins/rebar3_hex
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
    description = "rebar 3.0 is an Erlang build tool that makes it easy to compile and test Erlang applications, port drivers and releases";

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
