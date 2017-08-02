{ stdenv, writeText, callPackage, fetchurl,
  fetchHex, erlang, hermeticRebar3 ? true,
  tree, fetchFromGitHub, hexRegistrySnapshot }:

let
  version = "3.3.2";

  bootstrapper = ./rebar3-nix-bootstrap;

  bbmustache = fetchHex {
    pkg = "bbmustache";
    version = "1.3.0";
    sha256 = "042pfgss8kscq6ssg8gix8ccmdsrx0anjczsbrn2a6c36ljrx2p6";
  };
  certifi = fetchHex {
    pkg = "certifi";
    version = "0.4.0";
    sha256 = "04bnvsbssdcf6b9h9bfglflds7j0gx6q5igl1xxhx6fnwaz37hhw";
  };
  cf = fetchHex {
    pkg = "cf";
    version = "0.2.1";
    sha256 = "19d0yvg8wwa57cqhn3vqfvw978nafw8j2rvb92s3ryidxjkrmvms";
  };
  cth_readable = fetchHex {
    pkg = "cth_readable";
    version = "1.2.3";
    sha256 = "0wfpfismzi2q0nzvx9qyllch4skwmsk6yqffw8iw2v48ssbfvfhz";
  };
  erlware_commons = fetchHex {
    pkg = "erlware_commons";
    version = "0.21.0";
    sha256 = "0gxb011m637rca2g0vhm1q9krm3va50rz1py6zf8k92q4iv9a2p7";
  };
  eunit_formatters = fetchHex {
    pkg = "eunit_formatters";
    version = "0.3.1";
    sha256 = "0cg9dasv60v09q3q4wja76pld0546mhmlpb0khagyylv890hg934";
  };
  getopt = fetchHex {
    pkg = "getopt";
    version = "0.8.2";
    sha256 = "1xw30h59zbw957cyjd8n50hf9y09jnv9dyry6x3avfwzcyrnsvkk";
  };
  providers = fetchHex {
    pkg = "providers";
    version = "1.6.0";
    sha256 = "0byfa1h57n46jilz4q132j0vk3iqc0v1vip89li38gb1k997cs0g";
  };
  ssl_verify_fun = fetchHex {
    pkg = "ssl_verify_fun";
    version = "1.1.1";
    sha256 = "0pnnan9xf4r6pr34hi28zdyv501i39jwnrwk6pr9r4wabkmhb22g";
  };
  relx = fetchHex {
    pkg = "relx";
    version = "3.21.1";
    sha256 = "00590aqy0rfzgsnzxqgwbmn90imxxqlzmnmapy6bq76vw2rynvb8";
  };
  rebar3_hex = fetchHex {
    pkg = "rebar3_hex";
    version = "1.12.0";
    sha256 = "45467e93ae8d776c6038fdaeaffbc55d8f2f097f300a54dab9b81c6d1cf21f73";
  };

in
stdenv.mkDerivation {
  name = "rebar3-${version}";
  inherit version;

  src = fetchurl {
    url = "https://github.com/rebar/rebar3/archive/${version}.tar.gz";
    sha256 = "14nhc1bmna3b4y9qmd0lzpi0jdaw92r7ljg7vlghn297awsjgg6c";
  };

  inherit bootstrapper;

  patches = if hermeticRebar3 == true
  then  [ ./hermetic-bootstrap.patch ./hermetic-rebar3.patch ]
  else [];

  buildInputs = [ erlang tree  ];
  propagatedBuildInputs = [ hexRegistrySnapshot ];

  postPatch = ''
    echo postPatch
    ${erlang}/bin/escript ${bootstrapper} registry-only
    echo "$ERL_LIBS"
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
