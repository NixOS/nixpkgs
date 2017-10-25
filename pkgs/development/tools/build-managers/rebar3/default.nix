{ stdenv, writeText, callPackage, fetchurl,
  fetchHex, erlang, hermeticRebar3 ? true,
  tree, fetchFromGitHub, hexRegistrySnapshot }:

let
  version = "3.4.3";

  bootstrapper = ./rebar3-nix-bootstrap;

  erlware_commons = fetchHex {
    pkg = "erlware_commons";
    version = "1.0.0";
    sha256 = "0wkphbrjk19lxdwndy92v058qwcaz13bcgdzp33h21aa7vminzx7";
  };
  ssl_verify_fun = fetchHex {
    pkg = "ssl_verify_fun";
    version = "1.1.2";
    sha256 = "0qdyx70v09fydv4wzz1djnkixqj62ny40yjjhv2q6mh47lns2arj";
  };
  certifi = fetchHex {
    pkg = "certifi";
    version = "2.0.0";
    sha256 = "075v7cvny52jbhnskchd3fp68fxgp7qfvdls0haamcycxrn0dipx";
  };
  providers = fetchHex {
    pkg = "providers";
    version = "1.6.0";
    sha256 = "0byfa1h57n46jilz4q132j0vk3iqc0v1vip89li38gb1k997cs0g";
  };
  getopt = fetchHex {
    pkg = "getopt";
    version = "0.8.2";
    sha256 = "1xw30h59zbw957cyjd8n50hf9y09jnv9dyry6x3avfwzcyrnsvkk";
  };
  bbmustache = fetchHex {
    pkg = "bbmustache";
    version = "1.3.0";
    sha256 = "042pfgss8kscq6ssg8gix8ccmdsrx0anjczsbrn2a6c36ljrx2p6";
  };
  relx = fetchHex {
    pkg = "relx";
    version = "3.23.1";
    sha256 = "13j7wds2d7b8v3r9pwy3zhwhzywgwhn6l9gm3slqzyrs1jld0a9d";
  };
  cf = fetchHex {
    pkg = "cf";
    version = "0.2.2";
    sha256 = "08cvy7skn5d2k4manlx5k3anqgjdvajjhc5jwxbaszxw34q3na28";
  };
  cth_readable = fetchHex {
    pkg = "cth_readable";
    version = "1.3.0";
    sha256 = "1s7bqj6f2zpbyjmbfq2mm6vcz1jrxjr2nd0531wshsx6fnshqhvs";
  };
  eunit_formatters = fetchHex {
    pkg = "eunit_formatters";
    version = "0.3.1";
    sha256 = "0cg9dasv60v09q3q4wja76pld0546mhmlpb0khagyylv890hg934";
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
    sha256 = "1a05gpxxc3mx5v33kzpb5xnq5vglmjl0q8hrcvpinjlazcwbg531";
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
    maintainers = [ stdenv.lib.maintainers.gleber ];
  };
}
