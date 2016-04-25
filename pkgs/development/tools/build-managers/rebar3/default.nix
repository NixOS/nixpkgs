{ stdenv, writeText, callPackage, fetchurl,
  fetchHex, erlang, hermeticRebar3 ? true,
  tree, fetchFromGitHub, hexRegistrySnapshot }:

let
  version = "3.1.0";

  bootstrapper = ./rebar3-nix-bootstrap;

  erlware_commons = fetchHex {
    pkg = "erlware_commons";
    version = "0.19.0";
    sha256 = "1gfsy9bbhjb94c5ghff2niamn93x2x08lnklh6pp7sfr5i0gkgsv";
  };
  ssl_verify_hostname = fetchHex {
    pkg = "ssl_verify_hostname";
    version = "1.0.5";
    sha256 = "1gzavzqzljywx4l59gvhkjbr1dip4kxzjjz1s4wsn42f2kk13jzj";
  };
  certifi = fetchHex {
    pkg = "certifi";
    version = "0.4.0";
    sha256 = "04bnvsbssdcf6b9h9bfglflds7j0gx6q5igl1xxhx6fnwaz37hhw";
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
    version = "1.0.4";
    sha256 = "04lvwm7f78x8bys0js33higswjkyimbygp4n72cxz1kfnryx9c03";
  };
  relx = fetchHex {
    pkg = "relx";
    version = "3.17.0";
    sha256 = "1xjybi93m8gj9f9z3lkc7xbg3k5cw56yl78rcz5qfirr0223sby2";
  };
  cf = fetchHex {
    pkg = "cf";
    version = "0.2.1";
    sha256 = "19d0yvg8wwa57cqhn3vqfvw978nafw8j2rvb92s3ryidxjkrmvms";
  };
  cth_readable = fetchHex {
    pkg = "cth_readable";
    version = "1.2.2";
    sha256 = "0kb9v4998liwyidpjkhcg1nin6djjzxcx6b313pbjicbp4r58n3p";
  };
  eunit_formatters = fetchHex {
    pkg = "eunit_formatters";
    version = "0.3.1";
    sha256 = "0cg9dasv60v09q3q4wja76pld0546mhmlpb0khagyylv890hg934";
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
    sha256 = "0r4wpnpi81ha4iirv9hcif3vrgc82qd51kah7rnhvpym55wcy9ml";
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
    cp --no-preserve=mode -R ${ssl_verify_hostname} _build/default/lib/ssl_verify_hostname
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
    homepage = "https://github.com/rebar/rebar3";
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
