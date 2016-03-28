{ stdenv, writeText, callPackage, fetchurl,
  fetchHex, erlang, hermeticRebar3 ? true, rebar3-nix-bootstrap,
  tree, fetchFromGitHub, hexRegistrySnapshot }:

let
  version = "3.0.0-beta.4";

  # TODO: all these below probably should go into nixpkgs.erlangModules.sources.*
  # {erlware_commons,     "0.16.0"},
  erlware_commons = fetchHex {
    pkg = "erlware_commons";
    version = "0.16.0";
    sha256 = "0kh24d0001390wfx28d0xa874vrsfvjgj41g315vg4hac632krxx";
  };
  # {ssl_verify_hostname, "1.0.5"},
  ssl_verify_hostname = fetchHex {
    pkg = "ssl_verify_hostname";
    version = "1.0.5";
    sha256 = "1gzavzqzljywx4l59gvhkjbr1dip4kxzjjz1s4wsn42f2kk13jzj";
  };
  # {certifi,             "0.1.1"},
  certifi = fetchHex {
    pkg = "certifi";
    version = "0.1.1";
    sha256 = "0afylwqg74gprbg116asz0my2nipmki0512c8mdiq6xdiyjdvlg6";
  };
  # {providers,           "1.5.0"},
  providers = fetchHex {
    pkg = "providers";
    version = "1.5.0";
    sha256 = "1hc8sp2l1mmx9dfpmh1f8j9hayfg7541rmx05wb9cmvxvih7zyvf";
  };
  # {getopt,              "0.8.2"},
  getopt = fetchHex {
    pkg = "getopt";
    version = "0.8.2";
    sha256 = "1xw30h59zbw957cyjd8n50hf9y09jnv9dyry6x3avfwzcyrnsvkk";
  };
  # {bbmustache,          "1.0.4"},
  bbmustache = fetchHex {
    pkg = "bbmustache";
    version = "1.0.4";
    sha256 = "04lvwm7f78x8bys0js33higswjkyimbygp4n72cxz1kfnryx9c03";
  };
  # {relx,                "3.8.0"},
  relx = fetchHex {
    pkg = "relx";
    version = "3.8.0";
    sha256 = "0y89iirjz3kc1rzkdvc6p3ssmwcm2hqgkklhgm4pkbc14fcz57hq";
  };
  # {cf,                  "0.2.1"},
  cf = fetchHex {
    pkg = "cf";
    version = "0.2.1";
    sha256 = "19d0yvg8wwa57cqhn3vqfvw978nafw8j2rvb92s3ryidxjkrmvms";
  };
  # {cth_readable,        "1.1.0"},
  cth_readable = fetchHex {
    pkg = "cth_readable";
    version = "1.0.1";
    sha256 = "1cnc4fbypckqllfi5h73rdb24dz576k3177gzvp1kbymwkp1xcz1";
  };
  # {eunit_formatters,    "0.2.0"}
  eunit_formatters = fetchHex {
    pkg = "eunit_formatters";
    version = "0.2.0";
    sha256 = "03kiszlbgzscfd2ns7na6bzbfzmcqdb5cx3p6qy3657jk2fai332";
  };
  # {eunit_formatters,    "0.2.0"}
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
    sha256 = "0px66scjdia9aaa5z36qzxb848r56m0k98g0bxw065a2narsh4xy";
  };

  patches = if hermeticRebar3 == true
  then  [ ./hermetic-bootstrap.patch ./hermetic-rebar3.patch ]
  else [];

  buildInputs = [ erlang tree  ];
  propagatedBuildInputs = [ hexRegistrySnapshot rebar3-nix-bootstrap ];

  postPatch = ''
    echo postPatch
    rebar3-nix-bootstrap registry-only
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
