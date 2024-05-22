{ lib, newScope, pkgs, config }:

let
  liftJaneStreet = self: super: super.janeStreet // super;

  mkOcamlPackages = ocaml:
    (lib.makeScope newScope (self: with self;
  {
    inherit ocaml;

    ### A ###
    aches = callPackage ../development/ocaml-modules/aches { };
    aches-lwt = callPackage ../development/ocaml-modules/aches/lwt.nix { };

    afl-persistent = callPackage ../development/ocaml-modules/afl-persistent { };

    alcotest = callPackage ../development/ocaml-modules/alcotest {};

    alcotest-lwt = callPackage ../development/ocaml-modules/alcotest/lwt.nix {};

    alcotest-mirage = callPackage ../development/ocaml-modules/alcotest/mirage.nix {};

    algaeff = callPackage ../development/ocaml-modules/algaeff { };

    alsa = callPackage ../development/ocaml-modules/alsa { };

    angstrom = callPackage ../development/ocaml-modules/angstrom { };

    angstrom-async = callPackage ../development/ocaml-modules/angstrom-async { };

    angstrom-lwt-unix = callPackage ../development/ocaml-modules/angstrom-lwt-unix { };

    angstrom-unix = callPackage ../development/ocaml-modules/angstrom-unix { };

    ansiterminal = callPackage ../development/ocaml-modules/ansiterminal { };

    ao = callPackage ../development/ocaml-modules/ao { };

    apron = callPackage ../development/ocaml-modules/apron { };

    arp = callPackage ../development/ocaml-modules/arp { };

    asai = callPackage ../development/ocaml-modules/asai { };

    asetmap = callPackage ../development/ocaml-modules/asetmap { };

    asn1-combinators = callPackage ../development/ocaml-modules/asn1-combinators { };

    astring = callPackage ../development/ocaml-modules/astring { };

    atd = callPackage ../development/ocaml-modules/atd { };

    atdgen = callPackage ../development/ocaml-modules/atdgen { };

    atdgen-codec-runtime = callPackage ../development/ocaml-modules/atdgen/codec-runtime.nix { };

    atdgen-runtime = callPackage ../development/ocaml-modules/atdgen/runtime.nix { };

    awa = callPackage ../development/ocaml-modules/awa { };

    awa-mirage = callPackage ../development/ocaml-modules/awa/mirage.nix { };

    ### B ###

    b0 = callPackage ../development/ocaml-modules/b0 { };

    bap = janeStreet_0_15.bap;

    base64 = callPackage ../development/ocaml-modules/base64 { };

    batteries = callPackage ../development/ocaml-modules/batteries { };

    bdd = callPackage ../development/ocaml-modules/bdd { };

    benchmark = callPackage ../development/ocaml-modules/benchmark { };

    bheap = callPackage ../development/ocaml-modules/bheap { };

    bigarray-compat = callPackage ../development/ocaml-modules/bigarray-compat { };

    bigarray-overlap = callPackage ../development/ocaml-modules/bigarray-overlap { };

    bigstring = callPackage ../development/ocaml-modules/bigstring { };

    bigstringaf = callPackage ../development/ocaml-modules/bigstringaf { };

    bindlib = callPackage ../development/ocaml-modules/bindlib { };

    biniou = callPackage ../development/ocaml-modules/biniou { };

    binning = callPackage ../development/ocaml-modules/binning { };

    biocaml = janeStreet_0_15.biocaml;

    biotk = janeStreet_0_15.biotk;

    bisect_ppx = callPackage ../development/ocaml-modules/bisect_ppx { };

    bistro = callPackage ../development/ocaml-modules/bistro { };

    bitstring = callPackage ../development/ocaml-modules/bitstring { };

    bitv = callPackage ../development/ocaml-modules/bitv { };

    bjack = callPackage ../development/ocaml-modules/bjack {
      inherit (pkgs.darwin.apple_sdk.frameworks) Accelerate CoreAudio;
    };

    bls12-381 = callPackage ../development/ocaml-modules/bls12-381 { };
    bls12-381-gen = callPackage ../development/ocaml-modules/bls12-381/gen.nix { };

    bls12-381-signature = callPackage ../development/ocaml-modules/bls12-381-signature { };

    bos = callPackage ../development/ocaml-modules/bos { };

    brisk-reconciler = callPackage ../development/ocaml-modules/brisk-reconciler { };

    brr = callPackage ../development/ocaml-modules/brr { };

    bwd = callPackage ../development/ocaml-modules/bwd { };

    bytestring = callPackage ../development/ocaml-modules/bytestring { };

    bz2 = callPackage ../development/ocaml-modules/bz2 { };

    ### C ###

    ca-certs = callPackage ../development/ocaml-modules/ca-certs { };

    ca-certs-nss = callPackage ../development/ocaml-modules/ca-certs-nss { };

    cairo2 = callPackage ../development/ocaml-modules/cairo2 {
      inherit (pkgs.darwin.apple_sdk.frameworks) ApplicationServices;
    };

    calendar = callPackage ../development/ocaml-modules/calendar { };

    callipyge = callPackage ../development/ocaml-modules/callipyge { };

    camlidl = callPackage ../development/tools/ocaml/camlidl { };

    camlimages = callPackage ../development/ocaml-modules/camlimages { };

    camlp-streams = callPackage ../development/ocaml-modules/camlp-streams { };

    camlp4 =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/tools/ocaml/camlp4 { }
      else null;

    camlp5 = callPackage ../development/tools/ocaml/camlp5 { };

    # Compatibility alias
    camlp5_strict = camlp5;

    camlpdf = callPackage ../development/ocaml-modules/camlpdf { };

    camlzip = callPackage ../development/ocaml-modules/camlzip { };

    camomile =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/camomile { }
      else callPackage ../development/ocaml-modules/camomile/0.8.5.nix { };

    capnp = callPackage ../development/ocaml-modules/capnp { };

    caqti = callPackage ../development/ocaml-modules/caqti { };

    caqti-async = callPackage ../development/ocaml-modules/caqti/async.nix { };

    caqti-driver-mariadb = callPackage ../development/ocaml-modules/caqti/driver-mariadb.nix { };

    caqti-driver-postgresql = callPackage ../development/ocaml-modules/caqti/driver-postgresql.nix { };

    caqti-driver-sqlite3 = callPackage ../development/ocaml-modules/caqti/driver-sqlite3.nix { };

    caqti-dynload = callPackage ../development/ocaml-modules/caqti/dynload.nix { };

    caqti-lwt = callPackage ../development/ocaml-modules/caqti/lwt.nix { };

    caqti-type-calendar = callPackage ../development/ocaml-modules/caqti/type-calendar.nix { };

    carton = callPackage ../development/ocaml-modules/carton { };

    carton-git = callPackage ../development/ocaml-modules/carton/git.nix { };

    carton-lwt = callPackage ../development/ocaml-modules/carton/lwt.nix {
      git-binary = pkgs.git;
    };

    cfstream = callPackage ../development/ocaml-modules/cfstream { };

    chacha = callPackage ../development/ocaml-modules/chacha { };

    checkseum = callPackage ../development/ocaml-modules/checkseum { };

    chrome-trace = callPackage ../development/ocaml-modules/chrome-trace { };

    cil = callPackage ../development/ocaml-modules/cil { };

    clap = callPackage ../development/ocaml-modules/clap { };

    class_group_vdf = callPackage ../development/ocaml-modules/class_group_vdf { };

    cmarkit = callPackage ../development/ocaml-modules/cmarkit { };

    # The 1.1.0 release broke a lot of packages and is not compatible with
    # OCaml < 4.08.
    cmdliner =
      if lib.versionAtLeast ocaml.version "4.08"
      then cmdliner_1_1
      else cmdliner_1_0;

    cmdliner_1_0 = callPackage ../development/ocaml-modules/cmdliner/1_0.nix { };

    cmdliner_1_1 = callPackage ../development/ocaml-modules/cmdliner/1_1.nix { };

    cohttp = callPackage ../development/ocaml-modules/cohttp { };

    cohttp-async = callPackage ../development/ocaml-modules/cohttp/async.nix { };

    cohttp-lwt = callPackage ../development/ocaml-modules/cohttp/lwt.nix { };

    cohttp-lwt-jsoo = callPackage ../development/ocaml-modules/cohttp/lwt-jsoo.nix { };

    cohttp-lwt-unix = callPackage ../development/ocaml-modules/cohttp/lwt-unix.nix { };

    cohttp-mirage = callPackage ../development/ocaml-modules/cohttp/mirage.nix { };

    cohttp-top = callPackage ../development/ocaml-modules/cohttp/top.nix { };

    coin =  callPackage ../development/ocaml-modules/coin { };

    color = callPackage ../development/ocaml-modules/color { };

    colors = callPackage ../development/ocaml-modules/colors { };

    conduit = callPackage ../development/ocaml-modules/conduit { };

    conduit-async = callPackage ../development/ocaml-modules/conduit/async.nix { };

    conduit-lwt = callPackage ../development/ocaml-modules/conduit/lwt.nix { };

    conduit-lwt-unix = callPackage ../development/ocaml-modules/conduit/lwt-unix.nix { };

    conduit-mirage = callPackage ../development/ocaml-modules/conduit/mirage.nix { };

    config-file = callPackage ../development/ocaml-modules/config-file { };

    containers = callPackage ../development/ocaml-modules/containers { };

    containers-data = callPackage ../development/ocaml-modules/containers/data.nix { };

    cooltt = callPackage ../development/ocaml-modules/cooltt { };

    cow = callPackage ../development/ocaml-modules/cow { };

    cpdf = callPackage ../development/ocaml-modules/cpdf { };

    cppo = callPackage ../development/tools/ocaml/cppo { };

    cppo_ocamlbuild = callPackage ../development/tools/ocaml/cppo/ocamlbuild.nix { };

    cpu = callPackage ../development/ocaml-modules/cpu { };

    cpuid = callPackage ../development/ocaml-modules/cpuid { };

    crowbar = callPackage ../development/ocaml-modules/crowbar { };

    crunch = callPackage ../development/tools/ocaml/crunch { };

    cry = callPackage ../development/ocaml-modules/cry { };

    cryptokit = callPackage ../development/ocaml-modules/cryptokit { };

    csexp = callPackage ../development/ocaml-modules/csexp { };

    cstruct = callPackage ../development/ocaml-modules/cstruct {};

    cstruct-async = callPackage ../development/ocaml-modules/cstruct/async.nix { };

    cstruct-lwt = callPackage ../development/ocaml-modules/cstruct/lwt.nix { };

    cstruct-sexp = callPackage ../development/ocaml-modules/cstruct/sexp.nix {};

    cstruct-unix = callPackage ../development/ocaml-modules/cstruct/unix.nix {};

    csv = callPackage ../development/ocaml-modules/csv { };

    csv-lwt = callPackage ../development/ocaml-modules/csv/lwt.nix { };

    ctypes = callPackage ../development/ocaml-modules/ctypes { };

    ctypes-foreign = callPackage ../development/ocaml-modules/ctypes/foreign.nix { };

    ctypes_stubs_js = callPackage ../development/ocaml-modules/ctypes_stubs_js {
      inherit (pkgs) nodejs;
    };

    cudf = callPackage ../development/ocaml-modules/cudf { };

    curly = callPackage ../development/ocaml-modules/curly {
      inherit (pkgs) curl;
    };

    curses = callPackage ../development/ocaml-modules/curses { };

    ### D ###

    dap =  callPackage ../development/ocaml-modules/dap { };

    data-encoding = callPackage ../development/ocaml-modules/data-encoding { };

    dates_calc = callPackage ../development/ocaml-modules/dates_calc {  };

    dbf =  callPackage ../development/ocaml-modules/dbf { };

    decompress =  callPackage ../development/ocaml-modules/decompress { };

    dedukti =  callPackage ../development/ocaml-modules/dedukti { };

    diet =  callPackage ../development/ocaml-modules/diet { };

    digestif =  callPackage ../development/ocaml-modules/digestif { };

    directories =  callPackage ../development/ocaml-modules/directories { };

    dispatch =  callPackage ../development/ocaml-modules/dispatch { };

    dns =  callPackage ../development/ocaml-modules/dns { };

    dns-certify =  callPackage ../development/ocaml-modules/dns/certify.nix { };

    dns-cli =  callPackage ../development/ocaml-modules/dns/cli.nix { };

    dns-client =  callPackage ../development/ocaml-modules/dns/client.nix { };

    dns-client-lwt = callPackage ../development/ocaml-modules/dns/client-lwt.nix { };

    dns-client-mirage = callPackage ../development/ocaml-modules/dns/client-mirage.nix { };

    dns-mirage = callPackage ../development/ocaml-modules/dns/mirage.nix { };

    dns-resolver = callPackage ../development/ocaml-modules/dns/resolver.nix { };

    dns-server = callPackage ../development/ocaml-modules/dns/server.nix { };

    dns-stub = callPackage ../development/ocaml-modules/dns/stub.nix { };

    dns-tsig = callPackage ../development/ocaml-modules/dns/tsig.nix { };

    dnssec = callPackage ../development/ocaml-modules/dns/dnssec.nix { };

    dolmen =  callPackage ../development/ocaml-modules/dolmen { };

    dolmen_loop =  callPackage ../development/ocaml-modules/dolmen/loop.nix { };

    dolmen_type =  callPackage ../development/ocaml-modules/dolmen/type.nix { };

    dolog = callPackage ../development/ocaml-modules/dolog { };

    domain-local-await = callPackage ../development/ocaml-modules/domain-local-await { };

    domain-local-timeout = callPackage ../development/ocaml-modules/domain-local-timeout { };

    domain-name = callPackage ../development/ocaml-modules/domain-name { };

    domain_shims = callPackage ../development/ocaml-modules/domain_shims { };

    domainslib = callPackage ../development/ocaml-modules/domainslib { };

    dose3 = callPackage ../development/ocaml-modules/dose3 { };

    dot-merlin-reader = callPackage ../development/tools/ocaml/merlin/dot-merlin-reader.nix { };

    dscheck = callPackage ../development/ocaml-modules/dscheck { };

    dssi = callPackage ../development/ocaml-modules/dssi { };

    dtoa = callPackage ../development/ocaml-modules/dtoa { };

    dtools = callPackage ../development/ocaml-modules/dtools { };

    duff = callPackage ../development/ocaml-modules/duff { };

    dum = callPackage ../development/ocaml-modules/dum { };

    dune_1 = callPackage ../development/tools/ocaml/dune/1.nix { };

    dune_2 =
      if lib.versionAtLeast ocaml.version "4.08"
      then callPackage ../development/tools/ocaml/dune/2.nix { }
      else if lib.versionAtLeast ocaml.version "4.02"
      then pkgs.dune_2
      else throw "dune_2 is not available for OCaml ${ocaml.version}";

    dune_3 =
      if lib.versionAtLeast ocaml.version "4.08"
      then callPackage ../development/tools/ocaml/dune/3.nix { }
      else if lib.versionAtLeast ocaml.version "4.02"
      then pkgs.dune_3
      else throw "dune_3 is not available for OCaml ${ocaml.version}";

    dune-action-plugin = callPackage ../development/ocaml-modules/dune-action-plugin { };

    dune-build-info = callPackage ../development/ocaml-modules/dune-build-info { };

    dune-configurator = callPackage ../development/ocaml-modules/dune-configurator { };

    dune-glob = callPackage ../development/ocaml-modules/dune-glob { };

    dune-private-libs = callPackage ../development/ocaml-modules/dune-private-libs { };

    dune-release = callPackage ../development/tools/ocaml/dune-release {
      inherit (pkgs) opam git mercurial coreutils gnutar bzip2;
    };

    dune-rpc = callPackage ../development/ocaml-modules/dune-rpc { };

    dune-site = callPackage ../development/ocaml-modules/dune-site { };

    duppy = callPackage ../development/ocaml-modules/duppy { };

    duration =  callPackage ../development/ocaml-modules/duration { };

    dyn =  callPackage ../development/ocaml-modules/dyn { };

    dypgen = callPackage ../development/ocaml-modules/dypgen { };

    ### E ###

    earley = callPackage ../development/ocaml-modules/earley { };

    earlybird = callPackage ../development/ocaml-modules/earlybird { };

    easy-format = callPackage ../development/ocaml-modules/easy-format { };

    eigen = callPackage ../development/ocaml-modules/eigen { };

    eio = callPackage ../development/ocaml-modules/eio { };
    eio_linux = callPackage ../development/ocaml-modules/eio/linux.nix { };
    eio_main = callPackage ../development/ocaml-modules/eio/main.nix { };
    eio_posix = callPackage ../development/ocaml-modules/eio/posix.nix { };

    either = callPackage ../development/ocaml-modules/either { };

    elina = callPackage ../development/ocaml-modules/elina { };

    eliom = callPackage ../development/ocaml-modules/eliom { };

    elpi = callPackage ../development/ocaml-modules/elpi (
      let ppxlib_0_15 = if lib.versionAtLeast ppxlib.version "0.15"
        then ppxlib.override { version = "0.15.0"; }
        else ppxlib; in
      {
        ppx_deriving_0_15 = ppx_deriving.override { ppxlib = ppxlib_0_15; };
        inherit ppxlib_0_15;
      }
    );

    emile = callPackage ../development/ocaml-modules/emile { };

    encore = callPackage ../development/ocaml-modules/encore { };

    eqaf = callPackage ../development/ocaml-modules/eqaf { };

    erm_xml = callPackage ../development/ocaml-modules/erm_xml { };

    erm_xmpp = callPackage ../development/ocaml-modules/erm_xmpp { };

    ethernet = callPackage ../development/ocaml-modules/ethernet { };

    extlib = extlib-1-7-9;

    extlib-1-7-9 = callPackage ../development/ocaml-modules/extlib { };

    extlib-1-7-7 = callPackage ../development/ocaml-modules/extlib/1.7.7.nix { };

    ezjsonm = callPackage ../development/ocaml-modules/ezjsonm { };

    ezxmlm = callPackage ../development/ocaml-modules/ezxmlm { };

    ### F ###

    faad = callPackage ../development/ocaml-modules/faad { };

    facile = callPackage ../development/ocaml-modules/facile { };

    faraday = callPackage ../development/ocaml-modules/faraday { };

    faraday-async = callPackage ../development/ocaml-modules/faraday/async.nix { };

    faraday-lwt = callPackage ../development/ocaml-modules/faraday/lwt.nix { };

    faraday-lwt-unix = callPackage ../development/ocaml-modules/faraday/lwt-unix.nix { };

    farfadet = callPackage ../development/ocaml-modules/farfadet { };

    fdkaac = callPackage ../development/ocaml-modules/fdkaac { };

    ff = callPackage ../development/ocaml-modules/ff { };
    ff-pbt = callPackage ../development/ocaml-modules/ff/pbt.nix { };
    ff-sig = callPackage ../development/ocaml-modules/ff/sig.nix { };

    ffmpeg = callPackage ../development/ocaml-modules/ffmpeg { };
    ffmpeg-av = callPackage ../development/ocaml-modules/ffmpeg/ffmpeg-av.nix {
      inherit (pkgs) ffmpeg;
      inherit (pkgs.darwin.apple_sdk.frameworks) AudioToolbox VideoToolbox;
    };
    ffmpeg-avcodec = callPackage ../development/ocaml-modules/ffmpeg/ffmpeg-avcodec.nix {
      inherit (pkgs) ffmpeg;
      inherit (pkgs.darwin.apple_sdk.frameworks) AudioToolbox VideoToolbox;
    };
    ffmpeg-avdevice = callPackage ../development/ocaml-modules/ffmpeg/ffmpeg-avdevice.nix {
      inherit (pkgs) ffmpeg;
      inherit (pkgs.darwin.apple_sdk.frameworks) AppKit AudioToolbox AVFoundation Cocoa CoreImage ForceFeedback OpenGL VideoToolbox;
    };
    ffmpeg-avfilter = callPackage ../development/ocaml-modules/ffmpeg/ffmpeg-avfilter.nix {
      inherit (pkgs) ffmpeg;
      inherit (pkgs.darwin.apple_sdk.frameworks) AppKit CoreImage OpenGL VideoToolbox;
    };
    ffmpeg-avutil = callPackage ../development/ocaml-modules/ffmpeg/ffmpeg-avutil.nix {
      inherit (pkgs) ffmpeg;
      inherit (pkgs.darwin.apple_sdk.frameworks) AudioToolbox VideoToolbox;
    };
    ffmpeg-swresample = callPackage ../development/ocaml-modules/ffmpeg/ffmpeg-swresample.nix {
      inherit (pkgs) ffmpeg;
      inherit (pkgs.darwin.apple_sdk.frameworks) VideoToolbox;
    };
    ffmpeg-swscale = callPackage ../development/ocaml-modules/ffmpeg/ffmpeg-swscale.nix {
      inherit (pkgs) ffmpeg;
      inherit (pkgs.darwin.apple_sdk.frameworks) VideoToolbox;
    };

    fiber = callPackage ../development/ocaml-modules/fiber { };

    fileutils = callPackage ../development/ocaml-modules/fileutils { };

    findlib = callPackage ../development/tools/ocaml/findlib { };

    fix = callPackage ../development/ocaml-modules/fix { };

    flac = callPackage ../development/ocaml-modules/flac {
      inherit (pkgs) flac;
    };

    flex = callPackage ../development/ocaml-modules/flex { };

    fmt = callPackage ../development/ocaml-modules/fmt { };

    fontconfig = callPackage ../development/ocaml-modules/fontconfig {
      inherit (pkgs) fontconfig;
    };

    fpath = callPackage ../development/ocaml-modules/fpath { };

    frei0r = callPackage ../development/ocaml-modules/frei0r {
      inherit (pkgs) frei0r;
    };

    frontc = callPackage ../development/ocaml-modules/frontc { };

    functoria = callPackage ../development/ocaml-modules/functoria { };

    functoria-runtime = callPackage ../development/ocaml-modules/functoria/runtime.nix { };

    functory = callPackage ../development/ocaml-modules/functory { };

    ### G ###

    gapi-ocaml = callPackage ../development/ocaml-modules/gapi-ocaml { };

    gd4o = throw "ocamlPackages.gd4o is not maintained, use ocamlPackages.gd instead";
    gd = callPackage ../development/ocaml-modules/gd { inherit (pkgs) gd; };

    gen = callPackage ../development/ocaml-modules/gen { };

    gen_js_api = callPackage ../development/ocaml-modules/gen_js_api { };

    genspio = callPackage ../development/ocaml-modules/genspio { };

    getopt = callPackage ../development/ocaml-modules/getopt { };

    gettext-camomile = callPackage ../development/ocaml-modules/ocaml-gettext/camomile.nix { };

    gettext-stub = callPackage ../development/ocaml-modules/ocaml-gettext/stub.nix { };

    gg = callPackage ../development/ocaml-modules/gg { };

    git = callPackage ../development/ocaml-modules/git {
      git-binary = pkgs.git;
    };

    git-mirage = callPackage ../development/ocaml-modules/git/mirage.nix { };

    git-paf = callPackage ../development/ocaml-modules/git/paf.nix { };

    git-unix = callPackage ../development/ocaml-modules/git/unix.nix {
      git-binary = pkgs.git;
    };

    github = callPackage ../development/ocaml-modules/github {  };
    github-data = callPackage ../development/ocaml-modules/github/data.nix {  };
    github-jsoo = callPackage ../development/ocaml-modules/github/jsoo.nix {  };
    github-unix = callPackage ../development/ocaml-modules/github/unix.nix {  };

    gluten = callPackage ../development/ocaml-modules/gluten { };
    gluten-eio = callPackage ../development/ocaml-modules/gluten/eio.nix { };
    gluten-lwt = callPackage ../development/ocaml-modules/gluten/lwt.nix { };
    gluten-lwt-unix = callPackage ../development/ocaml-modules/gluten/lwt-unix.nix { };

    gmap = callPackage ../development/ocaml-modules/gmap { };

    gnuplot = callPackage ../development/ocaml-modules/gnuplot {
      inherit (pkgs) gnuplot;
    };

    graphics =
    if lib.versionOlder "4.09" ocaml.version
    then callPackage ../development/ocaml-modules/graphics { }
    else null;

    graphql = callPackage ../development/ocaml-modules/graphql { };

    graphql-cohttp = callPackage ../development/ocaml-modules/graphql/cohttp.nix { };

    graphql-lwt = callPackage ../development/ocaml-modules/graphql/lwt.nix { };

    graphql_parser = callPackage ../development/ocaml-modules/graphql/parser.nix { };

    graphql_ppx = callPackage ../development/ocaml-modules/graphql_ppx { };

    gsl = callPackage ../development/ocaml-modules/gsl {
      inherit (pkgs) gsl;
    };

    gstreamer = callPackage ../development/ocaml-modules/gstreamer {
      inherit (pkgs.darwin.apple_sdk.frameworks) AppKit Foundation;
    };

    ### H ###

    h2 = callPackage ../development/ocaml-modules/h2 { };

    hack_parallel = callPackage ../development/ocaml-modules/hack_parallel { };

    hacl-star = callPackage ../development/ocaml-modules/hacl-star { };
    hacl-star-raw = callPackage ../development/ocaml-modules/hacl-star/raw.nix { };

    happy-eyeballs = callPackage ../development/ocaml-modules/happy-eyeballs { };

    happy-eyeballs-lwt = callPackage ../development/ocaml-modules/happy-eyeballs/lwt.nix { };

    happy-eyeballs-mirage = callPackage ../development/ocaml-modules/happy-eyeballs/mirage.nix { };

    hashcons = callPackage ../development/ocaml-modules/hashcons { };

    hex = callPackage ../development/ocaml-modules/hex { };

    hidapi = callPackage ../development/ocaml-modules/hidapi { };

    higlo = callPackage ../development/ocaml-modules/higlo { };

    hkdf = callPackage ../development/ocaml-modules/hkdf { };

    hmap = callPackage ../development/ocaml-modules/hmap { };

    hpack = callPackage ../development/ocaml-modules/hpack { };

    http-mirage-client = callPackage ../development/ocaml-modules/http-mirage-client { };

    httpaf = callPackage ../development/ocaml-modules/httpaf { };

    httpaf-lwt-unix = callPackage ../development/ocaml-modules/httpaf/lwt-unix.nix { };

    hxd = callPackage ../development/ocaml-modules/hxd { };

    ### I ###

    imagelib = callPackage ../development/ocaml-modules/imagelib { };

    index = callPackage ../development/ocaml-modules/index { };

    inifiles = callPackage ../development/ocaml-modules/inifiles { };

    inotify = callPackage ../development/ocaml-modules/inotify { };

    integers = callPackage ../development/ocaml-modules/integers { };

    integers_stubs_js = callPackage ../development/ocaml-modules/integers_stubs_js { };

    iomux = callPackage ../development/ocaml-modules/iomux { };

    io-page = callPackage ../development/ocaml-modules/io-page { };

    ipaddr = callPackage ../development/ocaml-modules/ipaddr { };

    ipaddr-cstruct = callPackage ../development/ocaml-modules/ipaddr/cstruct.nix { };

    ipaddr-sexp = callPackage ../development/ocaml-modules/ipaddr/sexp.nix { };

    iri = callPackage ../development/ocaml-modules/iri { };

    irmin = callPackage ../development/ocaml-modules/irmin { };

    irmin-chunk = callPackage ../development/ocaml-modules/irmin/chunk.nix { };

    irmin-containers = callPackage ../development/ocaml-modules/irmin/containers.nix { };

    irmin-fs = callPackage ../development/ocaml-modules/irmin/fs.nix { };

    irmin-git = callPackage ../development/ocaml-modules/irmin/git.nix { };

    irmin-graphql = callPackage ../development/ocaml-modules/irmin/graphql.nix { };

    irmin-mirage = callPackage ../development/ocaml-modules/irmin/mirage.nix { };

    irmin-mirage-git = callPackage ../development/ocaml-modules/irmin/mirage-git.nix { };

    irmin-mirage-graphql = callPackage ../development/ocaml-modules/irmin/mirage-graphql.nix { };

    irmin-pack = callPackage ../development/ocaml-modules/irmin/pack.nix { };

    irmin-test = callPackage ../development/ocaml-modules/irmin/test.nix { };

    irmin-tezos = callPackage ../development/ocaml-modules/irmin/tezos.nix { };

    irmin-watcher = callPackage ../development/ocaml-modules/irmin-watcher { };

    iso8601 = callPackage ../development/ocaml-modules/iso8601 { };

    iter = callPackage ../development/ocaml-modules/iter { };

    ### J ###

    # Jane Street
    janePackage =
      if lib.versionOlder "4.13.1" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/janePackage_0_16.nix {}
      else if lib.versionOlder "4.10.2" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/janePackage_0_15.nix {}
      else if lib.versionOlder "4.08" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/janePackage_0_14.nix {}
      else if lib.versionOlder "4.07" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/janePackage_0_12.nix {}
      else null;

    janeStreet =
      if lib.versionOlder "4.13.1" ocaml.version
      then import ../development/ocaml-modules/janestreet/0.16.nix {
        inherit self;
        inherit (pkgs) bash fetchpatch fzf lib openssl zstd krb5;
      }
      else if lib.versionOlder "4.10.2" ocaml.version
      then import ../development/ocaml-modules/janestreet/0.15.nix {
        inherit self ocaml;
        inherit (pkgs) bash fetchpatch fzf lib openssl zstd;
      }
      else if lib.versionOlder "4.08" ocaml.version
      then import ../development/ocaml-modules/janestreet/0.14.nix {
        inherit self;
        inherit (pkgs) fetchpatch lib openssl zstd;
      }
      else if lib.versionOlder "4.07" ocaml.version
      then import ../development/ocaml-modules/janestreet/0.12.nix {
        self = self // {
          ppxlib = ppxlib.override { version = "0.8.1"; };
        };
        inherit (pkgs) openssl;
      }
      else import ../development/ocaml-modules/janestreet {
      };

    janeStreet_0_15 = (lib.makeScope self.newScope (self': with self'; {

      # ocamlPackages that janestreet v0.15 packages depend on.
      jsDeps = let
        uri-sexp = self.uri-sexp.override { inherit (self') ppx_sexp_conv sexplib0; };
        cohttp = self.cohttp.override {
          inherit (self') ppx_sexp_conv;
          inherit uri-sexp;
        };
        ipaddr-sexp = self.ipaddr-sexp.override { inherit (self') ppx_sexp_conv; };
        conduit = self.conduit.override {
          inherit (self') ppx_sexp_conv sexplib;
          inherit ipaddr-sexp;
        };
        conduit-async = self.conduit-async.override {
          inherit (self') async ppx_sexp_conv ppx_here core sexplib async_ssl;
          inherit conduit ipaddr-sexp;
        };
      in {
        inherit (self) dune-configurator alcotest re num octavius uutf ounit ctypes ctypes-foreign;
        ppxlib = self.ppxlib.override { inherit (self') stdio; };
        cohttp-async = self.cohttp-async.override {
          inherit (self') ppx_sexp_conv base async async_kernel async_unix core_unix sexplib0 core;
          inherit uri-sexp cohttp conduit-async;
        };
        janePackage = callPackage ../development/ocaml-modules/janestreet/janePackage_0_15.nix { };
      };

      janeStreet = import ../development/ocaml-modules/janestreet/0.15.nix {
        self = self' // jsDeps;
        inherit ocaml;
        inherit (pkgs) bash fetchpatch fzf lib openssl zstd;
      };

      # Packages that are not part of janestreet libraries, but still depend
      # on v0.15 are kept in this scope, too.

      bap = let
        ppxlib = jsDeps.ppxlib;
        lwt_ppx = self.lwt_ppx.override { inherit ppxlib; };
        sedlex = self.sedlex.override { inherit ppxlib ppx_expect; };
        in callPackage ../development/ocaml-modules/bap {
          inherit (pkgs.llvmPackages_14) llvm;
          ezjsonm = self.ezjsonm.override { inherit sexplib0; };
          ppx_bitstring = self.ppx_bitstring.override { inherit ppxlib; };
          ocurl = self.ocurl.override { inherit lwt_ppx; };
          piqi = self.piqi.override { inherit sedlex; };
          piqi-ocaml = self.piqi-ocaml.override { inherit piqi; };
        };

      biocaml = let
        angstrom = self.angstrom.override { inherit ppx_let; };
      in callPackage ../development/ocaml-modules/biocaml {
        uri = self.uri.override { inherit angstrom; };
        cfstream = self.cfstream.override { inherit core_kernel; };
      };

      biotk = let
        angstrom = self.angstrom.override { inherit ppx_let; };
      in callPackage ../development/ocaml-modules/biotk {
        angstrom-unix = self.angstrom-unix.override { inherit angstrom; };
        ppx_deriving = self.ppx_deriving.override { inherit (jsDeps) ppxlib; };
        uri = self.uri.override { inherit angstrom; };
        vg = self.vg.override { htmlcBackend = false; };
      };

      phylogenetics = let
        angstrom = self.angstrom.override { inherit ppx_let; };
      in callPackage ../development/ocaml-modules/phylogenetics {
        ppx_deriving = self.ppx_deriving.override { inherit (jsDeps) ppxlib; };
        angstrom-unix = self.angstrom-unix.override { inherit angstrom; };
      };

      ppx_bap = callPackage ../development/ocaml-modules/ppx_bap { };
    })).overrideScope liftJaneStreet;

    javalib = callPackage ../development/ocaml-modules/javalib { };

    jingoo = callPackage ../development/ocaml-modules/jingoo { };

    js_of_ocaml = callPackage ../development/tools/ocaml/js_of_ocaml { };

    js_of_ocaml-compiler = callPackage ../development/tools/ocaml/js_of_ocaml/compiler.nix {};

    js_of_ocaml-lwt = callPackage ../development/tools/ocaml/js_of_ocaml/lwt.nix {};

    js_of_ocaml-ocamlbuild = callPackage ../development/tools/ocaml/js_of_ocaml/ocamlbuild.nix {};

    js_of_ocaml-ppx = callPackage ../development/tools/ocaml/js_of_ocaml/ppx.nix {};

    js_of_ocaml-ppx_deriving_json = callPackage ../development/tools/ocaml/js_of_ocaml/ppx_deriving_json.nix { };

    js_of_ocaml-toplevel = callPackage ../development/tools/ocaml/js_of_ocaml/toplevel.nix {};

    js_of_ocaml-tyxml = callPackage ../development/tools/ocaml/js_of_ocaml/tyxml.nix {};

    json-data-encoding = callPackage ../development/ocaml-modules/json-data-encoding { };

    json-data-encoding-bson = callPackage ../development/ocaml-modules/json-data-encoding/bson.nix { };

    jsonm = callPackage ../development/ocaml-modules/jsonm { };

    jsonrpc = callPackage ../development/ocaml-modules/ocaml-lsp/jsonrpc.nix { };

    junit = callPackage ../development/ocaml-modules/junit { };
    junit_alcotest = callPackage ../development/ocaml-modules/junit/alcotest.nix { };
    junit_ounit = callPackage ../development/ocaml-modules/junit/ounit.nix { };

    jwto = callPackage ../development/ocaml-modules/jwto { };

    ### K ###

    kafka = callPackage ../development/ocaml-modules/kafka { };

    kafka_lwt = callPackage ../development/ocaml-modules/kafka/lwt.nix { };

    kcas = callPackage ../development/ocaml-modules/kcas { };

    ke = callPackage ../development/ocaml-modules/ke { };

    kicadsch = callPackage ../development/ocaml-modules/kicadsch { };

    kqueue = callPackage ../development/ocaml-modules/kqueue { };

    ### L ###

    lablgl = callPackage ../development/ocaml-modules/lablgl { };

    lablgtk = callPackage ../development/ocaml-modules/lablgtk {
      inherit (pkgs.gnome2) libgnomecanvas gtksourceview;
    };

    lablgtk-extras =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/lablgtk-extras { }
      else callPackage ../development/ocaml-modules/lablgtk-extras/1.4.nix { };

    lablgtk3 = callPackage ../development/ocaml-modules/lablgtk3 { };

    lablgtk3-gtkspell3 = callPackage ../development/ocaml-modules/lablgtk3/gtkspell3.nix { };

    lablgtk3-rsvg2 = callPackage ../development/ocaml-modules/lablgtk3/rsvg2.nix { };

    lablgtk3-sourceview3 = callPackage ../development/ocaml-modules/lablgtk3/sourceview3.nix { };

    labltk = callPackage ../development/ocaml-modules/labltk {
      inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa;
    };

    lacaml = callPackage ../development/ocaml-modules/lacaml { };

    ladspa = callPackage ../development/ocaml-modules/ladspa { };

    lambda-term = callPackage ../development/ocaml-modules/lambda-term { };

    lambdapi = callPackage ../development/ocaml-modules/lambdapi {
      why3 = pkgs.why3.override { ocamlPackages = self; };
    };

    lambdasoup = callPackage ../development/ocaml-modules/lambdasoup { };

    lame = callPackage ../development/ocaml-modules/lame {
      inherit (pkgs) lame;
    };

    landmarks = callPackage ../development/ocaml-modules/landmarks { };

    landmarks-ppx = callPackage ../development/ocaml-modules/landmarks-ppx { };

    lastfm = callPackage ../development/ocaml-modules/lastfm { };

    lem = callPackage ../development/ocaml-modules/lem { };

    lens = callPackage ../development/ocaml-modules/lens { };

    letsencrypt = callPackage ../development/ocaml-modules/letsencrypt { };

    letsencrypt-app = callPackage ../development/ocaml-modules/letsencrypt/app.nix { };

    letsencrypt-dns = callPackage ../development/ocaml-modules/letsencrypt/dns.nix { };

    letsencrypt-mirage = callPackage ../development/ocaml-modules/letsencrypt/mirage.nix { };

    lilv = callPackage ../development/ocaml-modules/lilv {
      inherit (pkgs) lilv;
    };

    linenoise = callPackage ../development/ocaml-modules/linenoise { };

    linksem = callPackage ../development/ocaml-modules/linksem { };

    linol = callPackage ../development/ocaml-modules/linol { };

    linol-lwt = callPackage ../development/ocaml-modules/linol/lwt.nix { };

    llvm = callPackage ../development/ocaml-modules/llvm {
      libllvm = pkgs.llvmPackages.libllvm;
    };

    lo = callPackage ../development/ocaml-modules/lo { };

    logs = callPackage ../development/ocaml-modules/logs { };

    lru = callPackage ../development/ocaml-modules/lru { };

    lsp = callPackage ../development/ocaml-modules/ocaml-lsp/lsp.nix { };

    lua-ml = callPackage ../development/ocaml-modules/lua-ml { };

    lun = callPackage ../development/ocaml-modules/lun { };

    lustre-v6 = callPackage ../development/ocaml-modules/lustre-v6 { };

    lutils = callPackage ../development/ocaml-modules/lutils { };

    luv = callPackage ../development/ocaml-modules/luv {
      inherit (pkgs) file;
    };

    lwd = callPackage ../development/ocaml-modules/lwd { };

    lwt = callPackage ../development/ocaml-modules/lwt { };

    lwt-canceler = callPackage ../development/ocaml-modules/lwt-canceler { };

    lwt_camlp4 = callPackage ../development/ocaml-modules/lwt/camlp4.nix { };

    lwt-dllist = callPackage ../development/ocaml-modules/lwt-dllist { };

    lwt-exit = callPackage ../development/ocaml-modules/lwt-exit { };

    lwt_log = callPackage ../development/ocaml-modules/lwt_log { };

    lwt_ppx = callPackage ../development/ocaml-modules/lwt/ppx.nix { };

    lwt_react = callPackage ../development/ocaml-modules/lwt_react { };

    lwt_ssl = callPackage ../development/ocaml-modules/lwt_ssl { };

    lwt-watcher = callPackage ../development/ocaml-modules/lwt-watcher { };

    ### M ###

    macaddr = callPackage ../development/ocaml-modules/macaddr { };

    macaddr-cstruct = callPackage ../development/ocaml-modules/macaddr/cstruct.nix { };

    macaddr-sexp = callPackage ../development/ocaml-modules/macaddr/sexp.nix { };

    mad = callPackage ../development/ocaml-modules/mad { };

    magic = callPackage ../development/ocaml-modules/magic { };

    magic-mime = callPackage ../development/ocaml-modules/magic-mime { };

    magic-trace = callPackage ../development/ocaml-modules/magic-trace { };

    mariadb = callPackage ../development/ocaml-modules/mariadb {
      inherit (pkgs) mariadb;
    };

    markup = callPackage ../development/ocaml-modules/markup { };

    mccs = callPackage ../development/ocaml-modules/mccs { };

    mdx = callPackage ../development/ocaml-modules/mdx {
      logs = logs.override { jsooSupport = false; lwtSupport = false; };
    };

    mec = callPackage ../development/ocaml-modules/mec { };

    memtrace = callPackage ../development/ocaml-modules/memtrace { };

    menhir = callPackage ../development/ocaml-modules/menhir { };

    menhirLib = callPackage ../development/ocaml-modules/menhir/lib.nix { };

    menhirSdk = callPackage ../development/ocaml-modules/menhir/sdk.nix { };

    merlin =
      if lib.versionAtLeast ocaml.version "4.12"
      then callPackage ../development/tools/ocaml/merlin/4.x.nix { }
      else callPackage ../development/tools/ocaml/merlin { };

    merlin-extend = callPackage ../development/ocaml-modules/merlin-extend { };

    merlin-lib = callPackage ../development/tools/ocaml/merlin/lib.nix { };

    metadata = callPackage ../development/ocaml-modules/metadata { };

    metrics = callPackage ../development/ocaml-modules/metrics { };

    metrics-influx = callPackage ../development/ocaml-modules/metrics/influx.nix { };

    metrics-lwt = callPackage ../development/ocaml-modules/metrics/lwt.nix { };

    metrics-rusage = callPackage ../development/ocaml-modules/metrics/rusage.nix { };

    metrics-unix = callPackage ../development/ocaml-modules/metrics/unix.nix {
      inherit (pkgs) gnuplot;
    };

    mew = callPackage ../development/ocaml-modules/mew { };

    mew_vi = callPackage ../development/ocaml-modules/mew_vi { };

    mezzo = callPackage ../development/compilers/mezzo { };

    middleware = callPackage ../development/ocaml-modules/middleware { };

    mimic = callPackage ../development/ocaml-modules/mimic { };

    mimic-happy-eyeballs = callPackage ../development/ocaml-modules/mimic/happy-eyeballs.nix { };

    minisat = callPackage ../development/ocaml-modules/minisat { };

    minttea = callPackage ../development/ocaml-modules/minttea { };

    miou = callPackage ../development/ocaml-modules/miou { };

    mirage = callPackage ../development/ocaml-modules/mirage { };

    mirage-block = callPackage ../development/ocaml-modules/mirage-block { };

    mirage-block-combinators = callPackage ../development/ocaml-modules/mirage-block/combinators.nix { };

    mirage-block-ramdisk = callPackage ../development/ocaml-modules/mirage-block-ramdisk { };

    mirage-block-unix = callPackage ../development/ocaml-modules/mirage-block-unix { };

    mirage-bootvar-unix = callPackage ../development/ocaml-modules/mirage-bootvar-unix { };

    mirage-bootvar-xen = callPackage ../development/ocaml-modules/mirage-bootvar-xen { };

    mirage-channel = callPackage ../development/ocaml-modules/mirage-channel { };

    mirage-clock = callPackage ../development/ocaml-modules/mirage-clock { };

    mirage-clock-solo5 = callPackage ../development/ocaml-modules/mirage-clock/solo5.nix { };

    mirage-clock-unix = callPackage ../development/ocaml-modules/mirage-clock/unix.nix { };

    mirage-console = callPackage ../development/ocaml-modules/mirage-console { };

    mirage-console-unix = callPackage ../development/ocaml-modules/mirage-console/unix.nix { };

    mirage-crypto = callPackage ../development/ocaml-modules/mirage-crypto { };

    mirage-crypto-ec = callPackage ../development/ocaml-modules/mirage-crypto/ec.nix { };

    mirage-crypto-pk = callPackage ../development/ocaml-modules/mirage-crypto/pk.nix { };

    mirage-crypto-rng = callPackage ../development/ocaml-modules/mirage-crypto/rng.nix { };

    mirage-crypto-rng-async = callPackage ../development/ocaml-modules/mirage-crypto/rng-async.nix { };

    mirage-crypto-rng-lwt = callPackage ../development/ocaml-modules/mirage-crypto/rng-lwt.nix { };

    mirage-crypto-rng-mirage = callPackage ../development/ocaml-modules/mirage-crypto/rng-mirage.nix { };

    mirage-device = callPackage ../development/ocaml-modules/mirage-device { };

    mirage-flow = callPackage ../development/ocaml-modules/mirage-flow { };

    mirage-flow-combinators = callPackage ../development/ocaml-modules/mirage-flow/combinators.nix { };

    mirage-flow-unix = callPackage ../development/ocaml-modules/mirage-flow/unix.nix { };

    mirage-kv = callPackage ../development/ocaml-modules/mirage-kv { };

    mirage-logs = callPackage ../development/ocaml-modules/mirage-logs { };

    mirage-nat = callPackage ../development/ocaml-modules/mirage-nat { };

    mirage-net = callPackage ../development/ocaml-modules/mirage-net { };

    mirage-net-xen = callPackage ../development/ocaml-modules/mirage-net-xen { };

    mirage-profile = callPackage ../development/ocaml-modules/mirage-profile { };

    mirage-protocols = callPackage ../development/ocaml-modules/mirage-protocols { };

    mirage-random = callPackage ../development/ocaml-modules/mirage-random { };

    mirage-random-test = callPackage ../development/ocaml-modules/mirage-random-test { };

    mirage-runtime = callPackage ../development/ocaml-modules/mirage/runtime.nix { };

    mirage-time = callPackage ../development/ocaml-modules/mirage-time { };

    mirage-time-unix = callPackage ../development/ocaml-modules/mirage-time/unix.nix { };

    mirage-unix = callPackage ../development/ocaml-modules/mirage-unix { };

    mirage-xen = callPackage ../development/ocaml-modules/mirage-xen { };

    mirage-vnetif = callPackage ../development/ocaml-modules/mirage-vnetif { };

    mldoc =  callPackage ../development/ocaml-modules/mldoc { };

    mlgmpidl =  callPackage ../development/ocaml-modules/mlgmpidl { };

    mm = callPackage ../development/ocaml-modules/mm { };

    mmap =  callPackage ../development/ocaml-modules/mmap { };

    morbig = callPackage ../development/ocaml-modules/morbig { };

    mparser =  callPackage ../development/ocaml-modules/mparser { };

    mparser-pcre =  callPackage ../development/ocaml-modules/mparser/pcre.nix { };

    msgpck = callPackage ../development/ocaml-modules/msgpck { };

    mrmime = callPackage ../development/ocaml-modules/mrmime { };

    msat = callPackage ../development/ocaml-modules/msat { };

    mtime =  callPackage ../development/ocaml-modules/mtime { };

    multipart-form-data =  callPackage ../development/ocaml-modules/multipart-form-data { };

    mustache =  callPackage ../development/ocaml-modules/mustache { };

    ### N ###

    netchannel = callPackage ../development/ocaml-modules/netchannel { };

    ninja_utils = callPackage ../development/ocaml-modules/ninja_utils { };

    nonstd =  callPackage ../development/ocaml-modules/nonstd { };

    note = callPackage ../development/ocaml-modules/note { };

    nottui = callPackage ../development/ocaml-modules/lwd/nottui.nix { };

    nottui-lwt = callPackage ../development/ocaml-modules/lwd/nottui-lwt.nix { };

    nottui-pretty = callPackage ../development/ocaml-modules/lwd/nottui-pretty.nix { };

    notty = callPackage ../development/ocaml-modules/notty { };

    npy = callPackage ../development/ocaml-modules/npy {
      inherit (pkgs.python3Packages) numpy;
    };

    num = if lib.versionOlder "4.06" ocaml.version
      then callPackage ../development/ocaml-modules/num {}
      else null;

    ### O ###

    ocaml_cairo = callPackage ../development/ocaml-modules/ocaml-cairo { };

    ocaml_cryptgps = callPackage ../development/ocaml-modules/cryptgps { };

    ocaml_expat = callPackage ../development/ocaml-modules/expat { };

    ocaml-freestanding = callPackage ../development/ocaml-modules/ocaml-freestanding { };

    ocaml_gettext = callPackage ../development/ocaml-modules/ocaml-gettext { };

    ocaml_libvirt = callPackage ../development/ocaml-modules/ocaml-libvirt {
      inherit (pkgs.darwin.apple_sdk.frameworks) Foundation AppKit;
    };

    ocaml-lsp = callPackage ../development/ocaml-modules/ocaml-lsp { };

    ocaml-lua = callPackage ../development/ocaml-modules/ocaml-lua { };

    ocaml_lwt = lwt;

    ocaml-migrate-parsetree = ocaml-migrate-parsetree-1-8;

    ocaml-migrate-parsetree-1-8 = callPackage ../development/ocaml-modules/ocaml-migrate-parsetree/1.8.x.nix { };

    ocaml-migrate-parsetree-2 = callPackage ../development/ocaml-modules/ocaml-migrate-parsetree/2.x.nix { };

    ocaml-monadic = callPackage ../development/ocaml-modules/ocaml-monadic { };

    ocaml_mysql = callPackage ../development/ocaml-modules/mysql { };

    ocaml_oasis = callPackage ../development/tools/ocaml/oasis { };

    ocaml_pcre = callPackage ../development/ocaml-modules/pcre {};

    ocaml-print-intf = callPackage ../development/ocaml-modules/ocaml-print-intf { };

    ocaml-protoc = callPackage ../development/ocaml-modules/ocaml-protoc { };

    ocaml-protoc-plugin = callPackage ../development/ocaml-modules/ocaml-protoc-plugin { };

    ocaml-r = callPackage ../development/ocaml-modules/ocaml-r { };

    ocaml-recovery-parser = callPackage ../development/tools/ocaml/ocaml-recovery-parser { };

    ocaml-sat-solvers = callPackage ../development/ocaml-modules/ocaml-sat-solvers { };

    ocaml_sqlite3 = callPackage ../development/ocaml-modules/sqlite3 { };

    ocaml-syntax-shims = callPackage ../development/ocaml-modules/ocaml-syntax-shims { };

    ocaml-version = callPackage ../development/ocaml-modules/ocaml-version { };

    ocaml-vdom = callPackage ../development/ocaml-modules/ocaml-vdom { };

    ocamlbuild =
      if lib.versionOlder "4.03" ocaml.version
        then callPackage ../development/tools/ocaml/ocamlbuild { }
        else null;

    ocamlc-loc = callPackage ../development/ocaml-modules/ocamlc-loc { };

    # Older versions of OCamlformat should be removed when their usage decrease
    # This script scraps Github looking for OCamlformat's options and versions usage:
    #  https://gist.github.com/Julow/110dc94308d6078225e0665e3eccd433
    ocamlformat_0_19_0 = ocamlformat.override { version = "0.19.0"; };
    ocamlformat_0_20_0 = ocamlformat.override { version = "0.20.0"; };
    ocamlformat_0_20_1 = ocamlformat.override { version = "0.20.1"; };
    ocamlformat_0_21_0 = ocamlformat.override { version = "0.21.0"; };
    ocamlformat_0_22_4 = ocamlformat.override { version = "0.22.4"; };
    ocamlformat_0_23_0 = ocamlformat.override { version = "0.23.0"; };
    ocamlformat_0_24_1 = ocamlformat.override { version = "0.24.1"; };
    ocamlformat_0_25_1 = ocamlformat.override { version = "0.25.1"; };
    ocamlformat_0_26_0 = ocamlformat.override { version = "0.26.0"; };
    ocamlformat_0_26_1 = ocamlformat.override { version = "0.26.1"; };
    ocamlformat_0_26_2 = ocamlformat.override { version = "0.26.2"; };

    ocamlformat = callPackage ../development/ocaml-modules/ocamlformat/ocamlformat.nix {};

    ocamlformat-lib = callPackage ../development/ocaml-modules/ocamlformat/ocamlformat-lib.nix { };

    ocamlformat-rpc-lib = callPackage ../development/ocaml-modules/ocamlformat/ocamlformat-rpc-lib.nix { };

    ocamlfuse = callPackage ../development/ocaml-modules/ocamlfuse { };

    ocamlgraph = callPackage ../development/ocaml-modules/ocamlgraph { };
    ocamlgraph_gtk = callPackage ../development/ocaml-modules/ocamlgraph/gtk.nix { };

    ocamlify = callPackage ../development/tools/ocaml/ocamlify { };

    ocamline = callPackage ../development/ocaml-modules/ocamline { };

    ocamlmod = callPackage ../development/tools/ocaml/ocamlmod { };

    ocamlnet = callPackage ../development/ocaml-modules/ocamlnet { };

    ocamlscript = callPackage ../development/tools/ocaml/ocamlscript { };

    ocb-stubblr = callPackage ../development/ocaml-modules/ocb-stubblr { };

    ocf = callPackage ../development/ocaml-modules/ocf { };

    ocf_ppx = callPackage ../development/ocaml-modules/ocf/ppx.nix { };

    ocolor = callPackage ../development/ocaml-modules/ocolor { };

    ocp-build = callPackage ../development/tools/ocaml/ocp-build { };

    ocp-indent = callPackage ../development/tools/ocaml/ocp-indent { };

    ocp-index = callPackage ../development/tools/ocaml/ocp-index { };

    ocp-ocamlres = callPackage ../development/ocaml-modules/ocp-ocamlres { };

    ocplib-endian = callPackage ../development/ocaml-modules/ocplib-endian { };

    ocplib-simplex = callPackage ../development/ocaml-modules/ocplib-simplex { };

    ocsigen-ppx-rpc = callPackage ../development/ocaml-modules/ocsigen-ppx-rpc { };

    ocsigen_server = callPackage ../development/ocaml-modules/ocsigen-server { };

    ocsigen-start = callPackage ../development/ocaml-modules/ocsigen-start { };

    ocsigen-toolkit = callPackage ../development/ocaml-modules/ocsigen-toolkit { };

    ocsipersist = callPackage ../development/ocaml-modules/ocsipersist {};

    ocsipersist-lib = callPackage ../development/ocaml-modules/ocsipersist/lib.nix { };

    ocsipersist-pgsql = callPackage ../development/ocaml-modules/ocsipersist/pgsql.nix { };

    ocsipersist-sqlite = callPackage ../development/ocaml-modules/ocsipersist/sqlite.nix { };

    octavius = callPackage ../development/ocaml-modules/octavius { };

    ocurl = callPackage ../development/ocaml-modules/ocurl { };

    odate = callPackage ../development/ocaml-modules/odate { };

    odig = callPackage ../development/ocaml-modules/odig { };

    odoc = callPackage ../development/ocaml-modules/odoc { };

    odoc-parser = callPackage ../development/ocaml-modules/odoc-parser { };

    ogg = callPackage ../development/ocaml-modules/ogg { };

    ojs = callPackage ../development/ocaml-modules/gen_js_api/ojs.nix { };

    omd = callPackage ../development/ocaml-modules/omd { };

    opam-core = callPackage ../development/ocaml-modules/opam-core {
      inherit (pkgs) opam unzip;
    };

    opam-file-format = callPackage ../development/ocaml-modules/opam-file-format { };

    opam-format = callPackage ../development/ocaml-modules/opam-format {
      inherit (pkgs) unzip;
    };

    opam-repository = callPackage ../development/ocaml-modules/opam-repository {
      inherit (pkgs) unzip;
    };

    opam-state = callPackage ../development/ocaml-modules/opam-state {
      inherit (pkgs) unzip;
    };

    opium = callPackage ../development/ocaml-modules/opium { };

    opti = callPackage ../development/ocaml-modules/opti { };

    optint = callPackage ../development/ocaml-modules/optint { };

    opus = callPackage ../development/ocaml-modules/opus { };

    ordering = callPackage ../development/ocaml-modules/ordering { };

    oseq = callPackage ../development/ocaml-modules/oseq { };

    otfed = callPackage ../development/ocaml-modules/otfed { };

    otfm = callPackage ../development/ocaml-modules/otfm { };

    otoml = callPackage ../development/ocaml-modules/otoml { };

    otr = callPackage ../development/ocaml-modules/otr { };

    ounit = callPackage ../development/ocaml-modules/ounit { };

    ounit2 = callPackage ../development/ocaml-modules/ounit2 { };

    owee = callPackage ../development/ocaml-modules/owee { };

    owl = callPackage ../development/ocaml-modules/owl { };

    owl-base = callPackage ../development/ocaml-modules/owl-base { };

    ### P ###

    paf = callPackage ../development/ocaml-modules/paf { };

    paf-cohttp = callPackage ../development/ocaml-modules/paf/cohttp.nix { };

    parany = callPackage ../development/ocaml-modules/parany { };

    parmap = callPackage ../development/ocaml-modules/parmap { };

    parse-argv = callPackage ../development/ocaml-modules/parse-argv { };

    path_glob = callPackage ../development/ocaml-modules/path_glob { };

    pbkdf = callPackage ../development/ocaml-modules/pbkdf { };

    pbrt = callPackage ../development/ocaml-modules/pbrt { };

    pcap-format = callPackage ../development/ocaml-modules/pcap-format { };

    pecu = callPackage ../development/ocaml-modules/pecu { };

    pgocaml = callPackage ../development/ocaml-modules/pgocaml {};

    pgocaml_ppx = callPackage ../development/ocaml-modules/pgocaml/ppx.nix {};

    pgsolver = callPackage ../development/ocaml-modules/pgsolver { };

    phylogenetics = janeStreet_0_15.phylogenetics;

    piaf = callPackage ../development/ocaml-modules/piaf { };

    piqi = callPackage ../development/ocaml-modules/piqi { };

    piqi-ocaml = callPackage ../development/ocaml-modules/piqi-ocaml { };

    plotkicadsch = callPackage ../development/ocaml-modules/plotkicadsch {
      inherit (pkgs) coreutils imagemagick;
    };

    poll = callPackage ../development/ocaml-modules/poll { };

    polynomial = callPackage ../development/ocaml-modules/polynomial { };

    portaudio = callPackage ../development/ocaml-modules/portaudio {
      inherit (pkgs) portaudio;
    };

    posix-base = callPackage ../development/ocaml-modules/posix/base.nix { };

    posix-socket = callPackage ../development/ocaml-modules/posix/socket.nix { };

    posix-time2 = callPackage ../development/ocaml-modules/posix/time2.nix { };

    posix-types = callPackage ../development/ocaml-modules/posix/types.nix { };

    postgresql = callPackage ../development/ocaml-modules/postgresql {
      inherit (pkgs) postgresql;
    };

    pp = callPackage ../development/ocaml-modules/pp { };

    pp_loc = callPackage ../development/ocaml-modules/pp_loc { };

    pprint = callPackage ../development/ocaml-modules/pprint { };

    ppx_bap = janeStreet_0_15.ppx_bap;

    ppx_bitstring = callPackage ../development/ocaml-modules/bitstring/ppx.nix { };

    ppx_blob = callPackage ../development/ocaml-modules/ppx_blob { };

    ppx_cstruct = callPackage ../development/ocaml-modules/cstruct/ppx.nix { };

    ppx_cstubs = callPackage ../development/ocaml-modules/ppx_cstubs { };

    ppx_derivers = callPackage ../development/ocaml-modules/ppx_derivers {};

    ppx_deriving = callPackage ../development/ocaml-modules/ppx_deriving {};

    ppx_deriving_cmdliner = callPackage ../development/ocaml-modules/ppx_deriving_cmdliner {};

    ppx_deriving_protobuf = callPackage ../development/ocaml-modules/ppx_deriving_protobuf {};

    ppx_deriving_qcheck = callPackage ../development/ocaml-modules/qcheck/ppx_deriving_qcheck.nix {};

    ppx_deriving_rpc = callPackage ../development/ocaml-modules/ppx_deriving_rpc { };

    ppx_deriving_yaml = callPackage ../development/ocaml-modules/ppx_deriving_yaml {};

    ppx_deriving_yojson = callPackage ../development/ocaml-modules/ppx_deriving_yojson {};

    ppx_gen_rec = callPackage ../development/ocaml-modules/ppx_gen_rec {};

    ppx_import = callPackage ../development/ocaml-modules/ppx_import {};

    ppx_irmin = callPackage ../development/ocaml-modules/irmin/ppx.nix { };

    ppx_lun = callPackage ../development/ocaml-modules/lun/ppx.nix { };

    ppx_monad = callPackage ../development/ocaml-modules/ppx_monad { };

    ppx_repr = callPackage ../development/ocaml-modules/repr/ppx.nix { };

    ppx_show = callPackage ../development/ocaml-modules/ppx_show { };

    ppx_tools =
      if lib.versionAtLeast ocaml.version "4.02"
      then callPackage ../development/ocaml-modules/ppx_tools {}
      else null;

    ppx_tools_versioned = callPackage ../development/ocaml-modules/ppx_tools_versioned { };

    ppx_yojson_conv = callPackage ../development/ocaml-modules/ppx_yojson_conv {};

    ppx_yojson_conv_lib = callPackage ../development/ocaml-modules/ppx_yojson_conv_lib {};

    ppxlib = callPackage ../development/ocaml-modules/ppxlib { };

    pratter = callPackage ../development/ocaml-modules/pratter { };

    prettym = callPackage ../development/ocaml-modules/prettym { };

    printbox = callPackage ../development/ocaml-modules/printbox { };

    printbox-text = callPackage ../development/ocaml-modules/printbox/text.nix { };

    process = callPackage ../development/ocaml-modules/process { };

    prometheus = callPackage ../development/ocaml-modules/prometheus { };

    progress = callPackage ../development/ocaml-modules/progress { };

    promise_jsoo = callPackage ../development/ocaml-modules/promise_jsoo { };

    psmt2-frontend = callPackage ../development/ocaml-modules/psmt2-frontend { };

    psq = callPackage ../development/ocaml-modules/psq { };

    ptime = callPackage ../development/ocaml-modules/ptime { };

    ptmap = callPackage ../development/ocaml-modules/ptmap { };

    ptset = callPackage ../development/ocaml-modules/ptset { };

    pulseaudio = callPackage ../development/ocaml-modules/pulseaudio {
      inherit (pkgs) pulseaudio;
    };

    pure-splitmix = callPackage ../development/ocaml-modules/pure-splitmix { };

    pyml = callPackage ../development/ocaml-modules/pyml { };

    ### Q ###

    qcheck = callPackage ../development/ocaml-modules/qcheck { };

    qcheck-alcotest = callPackage ../development/ocaml-modules/qcheck/alcotest.nix { };

    qcheck-core = callPackage ../development/ocaml-modules/qcheck/core.nix { };

    qcheck-lin = callPackage ../development/ocaml-modules/qcheck/lin.nix { };

    qcheck-multicoretests-util = callPackage ../development/ocaml-modules/qcheck/multicoretests-util.nix { };

    qcheck-ounit = callPackage ../development/ocaml-modules/qcheck/ounit.nix { };

    qcheck-stm = callPackage ../development/ocaml-modules/qcheck/stm.nix { };

    qtest = callPackage ../development/ocaml-modules/qtest { };

    ### R ###

    randomconv = callPackage ../development/ocaml-modules/randomconv { };

    rdbg = callPackage ../development/ocaml-modules/rdbg { };

    re = callPackage ../development/ocaml-modules/re { };

    react = callPackage ../development/ocaml-modules/react { };

    reactivedata = callPackage ../development/ocaml-modules/reactivedata {};

    readline = callPackage ../development/ocaml-modules/readline {
      readline = pkgs.readline;
    };

    reason = callPackage ../development/compilers/reason { };

    reason-native = lib.recurseIntoAttrs (callPackage ../development/ocaml-modules/reason-native { });

    rebez = callPackage ../development/ocaml-modules/rebez { };

    reperf = callPackage ../development/ocaml-modules/reperf { };

    repr = callPackage ../development/ocaml-modules/repr { };

    res = callPackage ../development/ocaml-modules/res { };

    resource-pooling = callPackage ../development/ocaml-modules/resource-pooling { };

    resto = callPackage ../development/ocaml-modules/resto { };
    resto-acl = callPackage ../development/ocaml-modules/resto/acl.nix { };
    resto-cohttp = callPackage ../development/ocaml-modules/resto/cohttp.nix { };
    resto-cohttp-client = callPackage ../development/ocaml-modules/resto/cohttp-client.nix { };
    resto-cohttp-self-serving-client = callPackage ../development/ocaml-modules/resto/cohttp-self-serving-client.nix { };
    resto-cohttp-server = callPackage ../development/ocaml-modules/resto/cohttp-server.nix { };
    resto-directory = callPackage ../development/ocaml-modules/resto/directory.nix { };
    resto-json = callPackage ../development/ocaml-modules/resto/json.nix { };

    result = callPackage ../development/ocaml-modules/ocaml-result { };

    rfc7748 = callPackage ../development/ocaml-modules/rfc7748 { };

    ringo = callPackage ../development/ocaml-modules/ringo { };

    rio = callPackage ../development/ocaml-modules/rio { };

    riot = callPackage ../development/ocaml-modules/riot { };

    rock = callPackage ../development/ocaml-modules/rock { };

    rope = callPackage ../development/ocaml-modules/rope { };

    rosetta = callPackage ../development/ocaml-modules/rosetta { };

    routes = callPackage ../development/ocaml-modules/routes { };

    rpclib = callPackage ../development/ocaml-modules/rpclib { };

    rpclib-lwt = callPackage ../development/ocaml-modules/rpclib/lwt.nix { };

    rresult = callPackage ../development/ocaml-modules/rresult { };

    rusage = callPackage ../development/ocaml-modules/rusage { };

    ### S ###

    safepass = callPackage ../development/ocaml-modules/safepass { };

    sail = callPackage ../development/ocaml-modules/sail { };

    samplerate = callPackage ../development/ocaml-modules/samplerate { };

    saturn = callPackage ../development/ocaml-modules/saturn { };

    saturn_lockfree = callPackage ../development/ocaml-modules/saturn/lockfree.nix { };

    sawja = callPackage ../development/ocaml-modules/sawja { };

    secp256k1 = callPackage ../development/ocaml-modules/secp256k1 {
      inherit (pkgs) secp256k1;
    };

    secp256k1-internal = callPackage ../development/ocaml-modules/secp256k1-internal { };

    sedlex = callPackage ../development/ocaml-modules/sedlex { };

    sel = callPackage ../development/ocaml-modules/sel {};

    semaphore-compat = callPackage ../development/ocaml-modules/semaphore-compat { };

    semver = callPackage ../development/ocaml-modules/semver { };

    seq = callPackage ../development/ocaml-modules/seq { };

    seqes = callPackage ../development/ocaml-modules/seqes { };

    sha = callPackage ../development/ocaml-modules/sha { };

    shared-memory-ring = callPackage ../development/ocaml-modules/shared-memory-ring { };

    shared-memory-ring-lwt = callPackage ../development/ocaml-modules/shared-memory-ring/lwt.nix { };

    shine = callPackage ../development/ocaml-modules/shine {
      inherit (pkgs) shine;
    };

    simple-diff = callPackage ../development/ocaml-modules/simple-diff { };

    slug = callPackage ../development/ocaml-modules/slug {  };

    sodium = callPackage ../development/ocaml-modules/sodium { };

    sosa = callPackage ../development/ocaml-modules/sosa { };

    soundtouch = callPackage ../development/ocaml-modules/soundtouch {
      inherit (pkgs) soundtouch;
    };

    speex = callPackage ../development/ocaml-modules/speex {
      inherit (pkgs) speex;
    };

    spelll = callPackage ../development/ocaml-modules/spelll { };

    spices = callPackage ../development/ocaml-modules/spices { };

    srt = callPackage ../development/ocaml-modules/srt {
      inherit (pkgs) srt;
    };

    ssl = callPackage ../development/ocaml-modules/ssl { };

    stdcompat = callPackage ../development/ocaml-modules/stdcompat { };

    stdint = callPackage ../development/ocaml-modules/stdint { };

    stdlib-shims = callPackage ../development/ocaml-modules/stdlib-shims { };

    stdune = callPackage ../development/ocaml-modules/stdune { };

    stog = callPackage ../applications/misc/stog { };
    stog_asy = callPackage ../applications/misc/stog/asy.nix { };
    stog_markdown = callPackage ../applications/misc/stog/markdown.nix { };

    streaming = callPackage ../development/ocaml-modules/streaming { };

    stringext = callPackage ../development/ocaml-modules/stringext { };

    syslog = callPackage ../development/ocaml-modules/syslog { };

    syslog-message = callPackage ../development/ocaml-modules/syslog-message { };

    ### T ###

    taglib = callPackage ../development/ocaml-modules/taglib {
      inherit (pkgs) taglib;
    };

    tar = callPackage ../development/ocaml-modules/tar { };

    tar-unix = callPackage ../development/ocaml-modules/tar/unix.nix {
      inherit (pkgs) git;
    };

    tcpip = callPackage ../development/ocaml-modules/tcpip { };

    tcslib = callPackage ../development/ocaml-modules/tcslib { };

    tdigest = callPackage ../development/ocaml-modules/tdigest { };

    telegraml = callPackage ../development/ocaml-modules/telegraml { };

    telemetry = callPackage ../development/ocaml-modules/telemetry { };

    terminal = callPackage ../development/ocaml-modules/terminal { };

    terminal_size = callPackage ../development/ocaml-modules/terminal_size { };

    tezos-base58 = callPackage ../development/ocaml-modules/tezos-base58 { };

    tezt = callPackage ../development/ocaml-modules/tezt { };

    theora = callPackage ../development/ocaml-modules/theora { };

    thread-table = callPackage ../development/ocaml-modules/thread-table { };

    timed = callPackage ../development/ocaml-modules/timed { };

    timedesc = callPackage ../development/ocaml-modules/timedesc { };
    timedesc-tzdb = callPackage ../development/ocaml-modules/timedesc/tzdb.nix { };
    timedesc-tzlocal = callPackage ../development/ocaml-modules/timedesc/tzlocal.nix { };

    tiny_httpd = callPackage ../development/ocaml-modules/tiny_httpd { };

    tls = callPackage ../development/ocaml-modules/tls { };

    tls-async = callPackage ../development/ocaml-modules/tls/async.nix { };

    tls-lwt = callPackage ../development/ocaml-modules/tls/lwt.nix { };

    tls-mirage = callPackage ../development/ocaml-modules/tls/mirage.nix { };

    toml = callPackage ../development/ocaml-modules/toml { };

    topkg = callPackage ../development/ocaml-modules/topkg { };

    torch = callPackage ../development/ocaml-modules/torch {
      torch = pkgs.libtorch-bin;
    };

    trace = callPackage ../development/ocaml-modules/trace { };

    trace-tef = callPackage ../development/ocaml-modules/trace/tef.nix { };

    trie = callPackage ../development/ocaml-modules/trie { };

    tsdl = callPackage ../development/ocaml-modules/tsdl {
      inherit (pkgs.darwin.apple_sdk.frameworks) AudioToolbox Cocoa CoreAudio CoreVideo ForceFeedback;
    };

    tsdl-image = callPackage ../development/ocaml-modules/tsdl-image { };

    tsdl-mixer = callPackage ../development/ocaml-modules/tsdl-mixer { };

    tsdl-ttf = callPackage ../development/ocaml-modules/tsdl-ttf { };

    tsort = callPackage ../development/ocaml-modules/tsort { };

    tty = callPackage ../development/ocaml-modules/tty { };

    tuntap = callPackage ../development/ocaml-modules/tuntap { };

    twt = callPackage ../development/ocaml-modules/twt { };

    type_eq = callPackage ../development/ocaml-modules/type_eq { };

    type_id = callPackage ../development/ocaml-modules/type_id { };

    tyxml = callPackage ../development/ocaml-modules/tyxml { };

    tyxml-lwd = callPackage ../development/ocaml-modules/lwd/tyxml-lwd.nix { };

    ### U ###

    uchar = callPackage ../development/ocaml-modules/uchar { };

    uecc = callPackage ../development/ocaml-modules/uecc { };

    ulex = callPackage ../development/ocaml-modules/ulex { };

    unionFind = callPackage ../development/ocaml-modules/unionFind { };

    unisim_archisec = callPackage ../development/ocaml-modules/unisim_archisec { };

    unix-errno = callPackage ../development/ocaml-modules/unix-errno { };

    unstrctrd = callPackage ../development/ocaml-modules/unstrctrd { };

    uri = callPackage ../development/ocaml-modules/uri { };

    uri-sexp = callPackage ../development/ocaml-modules/uri/sexp.nix { };

    uring = callPackage ../development/ocaml-modules/uring { };

    utop = callPackage ../development/tools/ocaml/utop { };

    uucd = callPackage ../development/ocaml-modules/uucd { };

    uucp = callPackage ../development/ocaml-modules/uucp { };

    uuidm = callPackage ../development/ocaml-modules/uuidm { };

    uunf = callPackage ../development/ocaml-modules/uunf { };

    uuseg = callPackage ../development/ocaml-modules/uuseg { };

    uutf = callPackage ../development/ocaml-modules/uutf { };

    uuuu = callPackage ../development/ocaml-modules/uuuu { };

    ### V ###

    vchan = callPackage ../development/ocaml-modules/vchan { };

    vector = callPackage ../development/ocaml-modules/vector { };

    vg = callPackage ../development/ocaml-modules/vg { };

    visitors = callPackage ../development/ocaml-modules/visitors { };

    vlq = callPackage ../development/ocaml-modules/vlq { };

    vorbis = callPackage ../development/ocaml-modules/vorbis { };

    vpl-core = callPackage ../development/ocaml-modules/vpl-core { };

    ### W ###

    wasm = callPackage ../development/ocaml-modules/wasm { };

    wayland = callPackage ../development/ocaml-modules/wayland { };

    webbrowser = callPackage ../development/ocaml-modules/webbrowser { };

    webmachine = callPackage ../development/ocaml-modules/webmachine { };

    wtf8 = callPackage ../development/ocaml-modules/wtf8 { };

    ### X ###

    x509 = callPackage ../development/ocaml-modules/x509 { };

    xdg = callPackage ../development/ocaml-modules/xdg { };

    xenstore = callPackage ../development/ocaml-modules/xenstore { };

    xenstore-tool = callPackage ../development/ocaml-modules/xenstore-tool { };

    xenstore_transport = callPackage ../development/ocaml-modules/xenstore_transport { };

    xml-light = callPackage ../development/ocaml-modules/xml-light { };

    xmlm = callPackage ../development/ocaml-modules/xmlm { };

    xmlplaylist = callPackage ../development/ocaml-modules/xmlplaylist { };

    xtmpl = callPackage ../development/ocaml-modules/xtmpl { };

    xtmpl_ppx = callPackage ../development/ocaml-modules/xtmpl/ppx.nix { };

    xxhash = callPackage ../development/ocaml-modules/xxhash/default.nix { };

    ### Y ###

    yaml = callPackage ../development/ocaml-modules/yaml { };

    yaml-sexp = callPackage ../development/ocaml-modules/yaml/yaml-sexp.nix { };

    yojson = callPackage ../development/ocaml-modules/yojson { };

    yuscii = callPackage ../development/ocaml-modules/yuscii { };

    yuujinchou = callPackage ../development/ocaml-modules/yuujinchou { };

    ### Z ###

    z3 = callPackage ../development/ocaml-modules/z3 {
      inherit (pkgs) z3;
    };

    zarith = callPackage ../development/ocaml-modules/zarith { };

    zed = callPackage ../development/ocaml-modules/zed { };

    zelus = callPackage ../development/ocaml-modules/zelus { };

    zelus-gtk = callPackage ../development/ocaml-modules/zelus-gtk { };

    zipc = callPackage ../development/ocaml-modules/zipc { };

    zmq = callPackage ../development/ocaml-modules/zmq { };

    zmq-lwt = callPackage ../development/ocaml-modules/zmq/lwt.nix { };

    ### Exceptional packages kept out of order ###

    # Libs

    buildDunePackage = callPackage ../build-support/ocaml/dune.nix { };

    buildOasisPackage = callPackage ../build-support/ocaml/oasis.nix { };

    buildTopkgPackage = callPackage ../build-support/ocaml/topkg.nix { };

    # Apps from all-packages, to be eventually removed

    google-drive-ocamlfuse = callPackage ../applications/networking/google-drive-ocamlfuse { };

    hol_light = callPackage ../applications/science/logic/hol_light { };

    ocamlnat = callPackage  ../development/ocaml-modules/ocamlnat { };

    ### End ###

  })).overrideScope liftJaneStreet;

in let inherit (pkgs) callPackage; in rec
{
  inherit mkOcamlPackages;

  ocamlPackages_4_00_1 = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.00.1.nix { });

  ocamlPackages_4_01_0 = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.01.0.nix { });

  ocamlPackages_4_02 = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.02.nix { });

  ocamlPackages_4_03 = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.03.nix { });

  ocamlPackages_4_04 = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.04.nix { });

  ocamlPackages_4_05 = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.05.nix { });

  ocamlPackages_4_06 = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.06.nix { });

  ocamlPackages_4_07 = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.07.nix { });

  ocamlPackages_4_08 = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.08.nix { });

  ocamlPackages_4_09 = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.09.nix { });

  ocamlPackages_4_10 = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.10.nix { });

  ocamlPackages_4_11 = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.11.nix { });

  ocamlPackages_4_12 = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.12.nix { });

  ocamlPackages_4_13 = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.13.nix { });

  ocamlPackages_4_14 = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.14.nix { });

  ocamlPackages_5_0 = mkOcamlPackages (callPackage ../development/compilers/ocaml/5.0.nix { });

  ocamlPackages_5_1 = mkOcamlPackages (callPackage ../development/compilers/ocaml/5.1.nix { });

  ocamlPackages_5_2 = mkOcamlPackages (callPackage ../development/compilers/ocaml/5.2.nix { });

  ocamlPackages_latest = ocamlPackages_5_2;

  ocamlPackages = ocamlPackages_5_1;

  # This is a nasty way to replace toplevel janestreet attributes in the scope,
  # so that modules outside of ocamlPackages that depend on JS OCaml libraries
  # *and* non-JS OCaml libraries can pull in the same version of JS transitive
  # dependencies. Remove this once ligo and stanc can be compiled against
  # janestreet 0.16 libraries.
  ocamlPackages_4_14_janeStreet_0_15 = ocamlPackages_4_14.overrideScope (self: super: super // super.janeStreet_0_15);

  # We still have packages that rely on unsafe-string, which is deprecated in OCaml 4.06.0.
  # Below are aliases for porting them to the latest versions of the OCaml 4 series.
  ocamlPackages_4_14_unsafe_string = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.14.nix {
    unsafeStringSupport = true;
  });
}
