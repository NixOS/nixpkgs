{ lib, newScope, pkgs, config }:

let
  liftJaneStreet = self: super: super.janeStreet // super;

  mkOcamlPackages = ocaml:
    (lib.makeScope newScope (self: with self;
  {
    inherit ocaml;

    # Libs

    buildOcaml = callPackage ../build-support/ocaml { };

    buildOasisPackage = callPackage ../build-support/ocaml/oasis.nix { };

    buildDunePackage = callPackage ../build-support/ocaml/dune.nix {};

    afl-persistent = callPackage ../development/ocaml-modules/afl-persistent { };

    alcotest = callPackage ../development/ocaml-modules/alcotest {};

    alcotest-lwt = callPackage ../development/ocaml-modules/alcotest/lwt.nix {};

    alcotest-mirage = callPackage ../development/ocaml-modules/alcotest/mirage.nix {};

    alsa = callPackage ../development/ocaml-modules/alsa { };

    angstrom = callPackage ../development/ocaml-modules/angstrom { };

    angstrom-async = callPackage ../development/ocaml-modules/angstrom-async { };

    angstrom-lwt-unix = callPackage ../development/ocaml-modules/angstrom-lwt-unix { };

    angstrom-unix = callPackage ../development/ocaml-modules/angstrom-unix { };

    ansiterminal = callPackage ../development/ocaml-modules/ansiterminal { };

    ao = callPackage ../development/ocaml-modules/ao { };

    apron = callPackage ../development/ocaml-modules/apron { };

    arp = callPackage ../development/ocaml-modules/arp { };

    asn1-combinators = callPackage ../development/ocaml-modules/asn1-combinators { };

    astring = callPackage ../development/ocaml-modules/astring { };

    atd = callPackage ../development/ocaml-modules/atd { };

    atdgen = callPackage ../development/ocaml-modules/atdgen { };

    atdgen-codec-runtime = callPackage ../development/ocaml-modules/atdgen/codec-runtime.nix { };

    atdgen-runtime = callPackage ../development/ocaml-modules/atdgen/runtime.nix { };

    awa = callPackage ../development/ocaml-modules/awa { };

    awa-lwt = callPackage ../development/ocaml-modules/awa/lwt.nix { };

    awa-mirage = callPackage ../development/ocaml-modules/awa/mirage.nix { };

    base64 = callPackage ../development/ocaml-modules/base64 { };

    bap = callPackage ../development/ocaml-modules/bap {
      inherit (pkgs.llvmPackages) llvm;
    };

    batteries = callPackage ../development/ocaml-modules/batteries { };

    bheap = callPackage ../development/ocaml-modules/bheap { };

    bigarray-compat = callPackage ../development/ocaml-modules/bigarray-compat { };

    bigarray-overlap = callPackage ../development/ocaml-modules/bigarray-overlap { };

    bigstringaf = callPackage ../development/ocaml-modules/bigstringaf { };

    bigstring = callPackage ../development/ocaml-modules/bigstring { };

    biocaml = callPackage ../development/ocaml-modules/biocaml { };

    bistro = callPackage ../development/ocaml-modules/bistro { };

    bitstring = callPackage ../development/ocaml-modules/bitstring { };

    bitv = callPackage ../development/ocaml-modules/bitv { };

    bjack = callPackage ../development/ocaml-modules/bjack { };

    bls12-381 = callPackage ../development/ocaml-modules/bls12-381 { };
    bls12-381-gen = callPackage ../development/ocaml-modules/bls12-381/gen.nix { };
    bls12-381-unix = callPackage ../development/ocaml-modules/bls12-381/unix.nix { };
    bls12-381-legacy = callPackage ../development/ocaml-modules/bls12-381/legacy.nix { };

    bos = callPackage ../development/ocaml-modules/bos { };

    brisk-reconciler = callPackage ../development/ocaml-modules/brisk-reconciler { };

    bwd = callPackage ../development/ocaml-modules/bwd { };

    bz2 = callPackage ../development/ocaml-modules/bz2 { };

    ca-certs = callPackage ../development/ocaml-modules/ca-certs { };

    ca-certs-nss = callPackage ../development/ocaml-modules/ca-certs-nss { };

    carton = callPackage ../development/ocaml-modules/carton { };

    carton-git = callPackage ../development/ocaml-modules/carton/git.nix { };

    carton-lwt = callPackage ../development/ocaml-modules/carton/lwt.nix {
      git-binary = pkgs.git;
    };

    camlidl = callPackage ../development/tools/ocaml/camlidl { };

    camlp-streams = callPackage ../development/ocaml-modules/camlp-streams { };

    camlp4 =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/tools/ocaml/camlp4 { }
      else null;

    camlp5 = callPackage ../development/tools/ocaml/camlp5 { };

    # Compatibility alias
    camlp5_strict = camlp5;

    camlpdf = callPackage ../development/ocaml-modules/camlpdf { };

    calendar = callPackage ../development/ocaml-modules/calendar { };

    camlzip = callPackage ../development/ocaml-modules/camlzip { };

    camomile_0_8_2 = callPackage ../development/ocaml-modules/camomile/0.8.2.nix { };
    camomile =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/camomile { }
      else callPackage ../development/ocaml-modules/camomile/0.8.5.nix { };

    camlimages_4_2_4 = callPackage ../development/ocaml-modules/camlimages/4.2.4.nix { };

    camlimages = callPackage ../development/ocaml-modules/camlimages { };

    benchmark = callPackage ../development/ocaml-modules/benchmark { };

    biniou = callPackage ../development/ocaml-modules/biniou { };

    bisect_ppx = callPackage ../development/ocaml-modules/bisect_ppx { };

    ocaml_cairo = callPackage ../development/ocaml-modules/ocaml-cairo { };

    cairo2 = callPackage ../development/ocaml-modules/cairo2 {
      inherit (pkgs.darwin.apple_sdk.frameworks) ApplicationServices;
    };

    callipyge = callPackage ../development/ocaml-modules/callipyge { };

    caqti = callPackage ../development/ocaml-modules/caqti { };

    caqti-async = callPackage ../development/ocaml-modules/caqti/async.nix { };

    caqti-driver-mariadb = callPackage ../development/ocaml-modules/caqti/driver-mariadb.nix { };

    caqti-driver-postgresql = callPackage ../development/ocaml-modules/caqti/driver-postgresql.nix { };

    caqti-driver-sqlite3 = callPackage ../development/ocaml-modules/caqti/driver-sqlite3.nix { };

    caqti-dynload = callPackage ../development/ocaml-modules/caqti/dynload.nix { };

    caqti-lwt = callPackage ../development/ocaml-modules/caqti/lwt.nix { };

    caqti-type-calendar = callPackage ../development/ocaml-modules/caqti/type-calendar.nix { };

    cfstream = callPackage ../development/ocaml-modules/cfstream { };

    chacha = callPackage ../development/ocaml-modules/chacha { };

    charInfo_width = callPackage ../development/ocaml-modules/charInfo_width { };

    checkseum = callPackage ../development/ocaml-modules/checkseum { };

    chrome-trace = callPackage ../development/ocaml-modules/chrome-trace { };

    cil = callPackage ../development/ocaml-modules/cil { };

    cmdliner_1_0 = callPackage ../development/ocaml-modules/cmdliner/1_0.nix { };

    cmdliner_1_1 = callPackage ../development/ocaml-modules/cmdliner/1_1.nix { };

    # The 1.1.0 release broke a lot of packages and is not compatible with
    # OCaml < 4.08.
    cmdliner = cmdliner_1_0;

    cohttp = callPackage ../development/ocaml-modules/cohttp { };

    cohttp-async = callPackage ../development/ocaml-modules/cohttp/async.nix { };

    cohttp-lwt = callPackage ../development/ocaml-modules/cohttp/lwt.nix { };

    cohttp-lwt-unix = callPackage ../development/ocaml-modules/cohttp/lwt-unix.nix { };

    cohttp-mirage = callPackage ../development/ocaml-modules/cohttp/mirage.nix { };

    color = callPackage ../development/ocaml-modules/color { };

    conduit = callPackage ../development/ocaml-modules/conduit { };

    conduit-async = callPackage ../development/ocaml-modules/conduit/async.nix { };

    conduit-lwt = callPackage ../development/ocaml-modules/conduit/lwt.nix { };

    conduit-lwt-unix = callPackage ../development/ocaml-modules/conduit/lwt-unix.nix { };

    conduit-mirage = callPackage ../development/ocaml-modules/conduit/mirage.nix { };

    coin =  callPackage ../development/ocaml-modules/coin { };

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

    csv =
      if lib.versionAtLeast ocaml.version "4.2"
      then callPackage ../development/ocaml-modules/csv { }
      else callPackage ../development/ocaml-modules/csv/1.5.nix { };

    csv-lwt = callPackage ../development/ocaml-modules/csv/lwt.nix { };

    cudf = callPackage ../development/ocaml-modules/cudf { };

    curly = callPackage ../development/ocaml-modules/curly {
      inherit (pkgs) curl;
    };

    curses = callPackage ../development/ocaml-modules/curses { };

    ctypes = callPackage ../development/ocaml-modules/ctypes { };

    dap =  callPackage ../development/ocaml-modules/dap { };

    data-encoding = callPackage ../development/ocaml-modules/data-encoding { };

    dbf =  callPackage ../development/ocaml-modules/dbf { };

    decompress =  callPackage ../development/ocaml-modules/decompress { };

    diet =  callPackage ../development/ocaml-modules/diet { };

    digestif =  callPackage ../development/ocaml-modules/digestif { };

    directories =  callPackage ../development/ocaml-modules/directories { };

    dispatch =  callPackage ../development/ocaml-modules/dispatch { };

    dns =  callPackage ../development/ocaml-modules/dns { };

    dns-certify =  callPackage ../development/ocaml-modules/dns/certify.nix { };

    dns-cli =  callPackage ../development/ocaml-modules/dns/cli.nix { };

    dns-client =  callPackage ../development/ocaml-modules/dns/client.nix { };

    dns-mirage = callPackage ../development/ocaml-modules/dns/mirage.nix { };

    dns-resolver = callPackage ../development/ocaml-modules/dns/resolver.nix { };

    dns-server = callPackage ../development/ocaml-modules/dns/server.nix { };

    dns-stub = callPackage ../development/ocaml-modules/dns/stub.nix { };

    dns-tsig = callPackage ../development/ocaml-modules/dns/tsig.nix { };

    dolmen =  callPackage ../development/ocaml-modules/dolmen { };

    dolog = callPackage ../development/ocaml-modules/dolog { };

    domain-name = callPackage ../development/ocaml-modules/domain-name { };

    dose3 = callPackage ../development/ocaml-modules/dose3 { };

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

    dune_3 = callPackage ../development/tools/ocaml/dune/3.nix { };

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

    earley = callPackage ../development/ocaml-modules/earley { };

    earlybird = callPackage ../development/ocaml-modules/earlybird { };

    easy-format = callPackage ../development/ocaml-modules/easy-format { };

    eigen = callPackage ../development/ocaml-modules/eigen { };

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

    encore = callPackage ../development/ocaml-modules/encore { };

    emile = callPackage ../development/ocaml-modules/emile { };

    eqaf = callPackage ../development/ocaml-modules/eqaf { };

    erm_xml = callPackage ../development/ocaml-modules/erm_xml { };

    erm_xmpp = callPackage ../development/ocaml-modules/erm_xmpp { };

    ethernet = callPackage ../development/ocaml-modules/ethernet { };

    ezjsonm = callPackage ../development/ocaml-modules/ezjsonm { };

    ezxmlm = callPackage ../development/ocaml-modules/ezxmlm { };

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
    ffmpeg-avutil = callPackage ../development/ocaml-modules/ffmpeg/ffmpeg-avutil.nix {
      inherit (pkgs) ffmpeg;
    };
    ffmpeg-avcodec = callPackage ../development/ocaml-modules/ffmpeg/ffmpeg-avcodec.nix {
      inherit (pkgs) ffmpeg;
    };
    ffmpeg-avfilter = callPackage ../development/ocaml-modules/ffmpeg/ffmpeg-avfilter.nix {
      inherit (pkgs) ffmpeg;
    };
    ffmpeg-swscale = callPackage ../development/ocaml-modules/ffmpeg/ffmpeg-swscale.nix {
      inherit (pkgs) ffmpeg;
    };
    ffmpeg-swresample = callPackage ../development/ocaml-modules/ffmpeg/ffmpeg-swresample.nix {
      inherit (pkgs) ffmpeg;
    };
    ffmpeg-av = callPackage ../development/ocaml-modules/ffmpeg/ffmpeg-av.nix {
      inherit (pkgs) ffmpeg;
    };
    ffmpeg-avdevice = callPackage ../development/ocaml-modules/ffmpeg/ffmpeg-avdevice.nix {
      inherit (pkgs) ffmpeg;
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

    functoria = callPackage ../development/ocaml-modules/functoria { };

    functoria-runtime = callPackage ../development/ocaml-modules/functoria/runtime.nix { };

    functory = callPackage ../development/ocaml-modules/functory { };

    gd4o = callPackage ../development/ocaml-modules/gd4o { };

    gen = callPackage ../development/ocaml-modules/gen { };

    genspio = callPackage ../development/ocaml-modules/genspio { };

    getopt = callPackage ../development/ocaml-modules/getopt { };

    gluten = callPackage ../development/ocaml-modules/gluten { };
    gluten-lwt = callPackage ../development/ocaml-modules/gluten/lwt.nix { };
    gluten-lwt-unix = callPackage ../development/ocaml-modules/gluten/lwt-unix.nix { };

    gmap = callPackage ../development/ocaml-modules/gmap { };

    gnuplot = callPackage ../development/ocaml-modules/gnuplot {
      inherit (pkgs) gnuplot;
    };

    gsl = callPackage ../development/ocaml-modules/gsl {
      inherit (pkgs) gsl;
    };

    gstreamer = callPackage ../development/ocaml-modules/gstreamer { };

    h2 = callPackage ../development/ocaml-modules/h2 { };

    hack_parallel = callPackage ../development/ocaml-modules/hack_parallel { };

    hacl-star = callPackage ../development/ocaml-modules/hacl-star { };
    hacl-star-raw = callPackage ../development/ocaml-modules/hacl-star/raw.nix { };

    happy-eyeballs = callPackage ../development/ocaml-modules/happy-eyeballs { };

    hashcons = callPackage ../development/ocaml-modules/hashcons { };

    herelib = callPackage ../development/ocaml-modules/herelib { };

    hidapi = callPackage ../development/ocaml-modules/hidapi { };

    higlo = callPackage ../development/ocaml-modules/higlo { };

    hkdf = callPackage ../development/ocaml-modules/hkdf { };

    hmap = callPackage ../development/ocaml-modules/hmap { };

    hpack = callPackage ../development/ocaml-modules/hpack { };

    hxd = callPackage ../development/ocaml-modules/hxd {
      cmdliner = cmdliner_1_1;
    };

    imagelib = callPackage ../development/ocaml-modules/imagelib { };

    inotify = callPackage ../development/ocaml-modules/inotify { };

    integers = callPackage ../development/ocaml-modules/integers { };

    io-page = callPackage ../development/ocaml-modules/io-page { };

    ipaddr = callPackage ../development/ocaml-modules/ipaddr { };

    ipaddr-cstruct = callPackage ../development/ocaml-modules/ipaddr/cstruct.nix { };

    ipaddr-sexp = callPackage ../development/ocaml-modules/ipaddr/sexp.nix { };

    iso8601 = callPackage ../development/ocaml-modules/iso8601 { };

    iter = callPackage ../development/ocaml-modules/iter { };

    javalib = callPackage ../development/ocaml-modules/javalib {
      extlib = ocaml_extlib;
    };

    dypgen = callPackage ../development/ocaml-modules/dypgen { };

    gapi-ocaml = callPackage ../development/ocaml-modules/gapi-ocaml { };

    gen_js_api = callPackage ../development/ocaml-modules/gen_js_api { };

    gg = callPackage ../development/ocaml-modules/gg { };

    git = callPackage ../development/ocaml-modules/git {
      git-binary = pkgs.git;
    };

    git-cohttp = callPackage ../development/ocaml-modules/git/cohttp.nix { };

    git-cohttp-unix = callPackage ../development/ocaml-modules/git/cohttp-unix.nix { };

    git-paf = callPackage ../development/ocaml-modules/git/paf.nix { };

    git-unix = callPackage ../development/ocaml-modules/git/unix.nix {
      git-binary = pkgs.git;
    };

    gmetadom = callPackage ../development/ocaml-modules/gmetadom { };

    graphics =
    if lib.versionOlder "4.09" ocaml.version
    then callPackage ../development/ocaml-modules/graphics { }
    else null;

    graphql = callPackage ../development/ocaml-modules/graphql { };

    graphql-cohttp = callPackage ../development/ocaml-modules/graphql/cohttp.nix { };

    graphql-lwt = callPackage ../development/ocaml-modules/graphql/lwt.nix { };

    graphql_parser = callPackage ../development/ocaml-modules/graphql/parser.nix { };

    graphql_ppx = callPackage ../development/ocaml-modules/graphql_ppx { };

    hex = callPackage ../development/ocaml-modules/hex { };

    httpaf = callPackage ../development/ocaml-modules/httpaf { };

    index = callPackage ../development/ocaml-modules/index { };

    inifiles = callPackage ../development/ocaml-modules/inifiles { };

    iri = callPackage ../development/ocaml-modules/iri { };

    irmin = callPackage ../development/ocaml-modules/irmin { };

    irmin-chunk = callPackage ../development/ocaml-modules/irmin/chunk.nix { };

    irmin-containers = callPackage ../development/ocaml-modules/irmin/containers.nix { };

    irmin-fs = callPackage ../development/ocaml-modules/irmin/fs.nix { };

    irmin-git = callPackage ../development/ocaml-modules/irmin/git.nix { };

    irmin-graphql = callPackage ../development/ocaml-modules/irmin/graphql.nix { };

    irmin-http = callPackage ../development/ocaml-modules/irmin/http.nix { };

    irmin-layers = callPackage ../development/ocaml-modules/irmin/layers.nix { };

    irmin-mirage = callPackage ../development/ocaml-modules/irmin/mirage.nix { };

    irmin-mirage-git = callPackage ../development/ocaml-modules/irmin/mirage-git.nix { };

    irmin-mirage-graphql = callPackage ../development/ocaml-modules/irmin/mirage-graphql.nix { };

    irmin-pack = callPackage ../development/ocaml-modules/irmin/pack.nix { };

    irmin-test = callPackage ../development/ocaml-modules/irmin/test.nix { };

    irmin-unix = callPackage ../development/ocaml-modules/irmin/unix.nix { };

    irmin-watcher = callPackage ../development/ocaml-modules/irmin-watcher { };

    jingoo = callPackage ../development/ocaml-modules/jingoo { };

    js_of_ocaml = callPackage ../development/tools/ocaml/js_of_ocaml { };

    js_of_ocaml-camlp4 = callPackage ../development/tools/ocaml/js_of_ocaml/camlp4.nix {};

    js_of_ocaml-compiler = callPackage ../development/tools/ocaml/js_of_ocaml/compiler.nix {};

    js_of_ocaml-lwt = callPackage ../development/tools/ocaml/js_of_ocaml/lwt.nix {};

    js_of_ocaml-ocamlbuild = callPackage ../development/tools/ocaml/js_of_ocaml/ocamlbuild.nix {};

    js_of_ocaml-ppx = callPackage ../development/tools/ocaml/js_of_ocaml/ppx.nix {};

    js_of_ocaml-ppx_deriving_json = callPackage ../development/tools/ocaml/js_of_ocaml/ppx_deriving_json.nix { };

    js_of_ocaml-tyxml = callPackage ../development/tools/ocaml/js_of_ocaml/tyxml.nix {};

    jsonm = callPackage ../development/ocaml-modules/jsonm { };

    json-data-encoding = callPackage ../development/ocaml-modules/json-data-encoding { };

    json-data-encoding-bson = callPackage ../development/ocaml-modules/json-data-encoding/bson.nix { };

    junit = callPackage ../development/ocaml-modules/junit { };
    junit_ounit = callPackage ../development/ocaml-modules/junit/ounit.nix { };
    junit_alcotest = callPackage ../development/ocaml-modules/junit/alcotest.nix { };

    jwto = callPackage ../development/ocaml-modules/jwto { };

    kafka = callPackage ../development/ocaml-modules/kafka { };

    kafka_lwt = callPackage ../development/ocaml-modules/kafka/lwt.nix { };

    ke = callPackage ../development/ocaml-modules/ke { };

    kicadsch = callPackage ../development/ocaml-modules/kicadsch { };

    lablgl = callPackage ../development/ocaml-modules/lablgl { };

    lablgtk3 = callPackage ../development/ocaml-modules/lablgtk3 { };

    lablgtk3-gtkspell3 = callPackage ../development/ocaml-modules/lablgtk3/gtkspell3.nix { };

    lablgtk3-sourceview3 = callPackage ../development/ocaml-modules/lablgtk3/sourceview3.nix { };

    lablgtk_2_14 = callPackage ../development/ocaml-modules/lablgtk/2.14.0.nix {
      inherit (pkgs.gnome2) libgnomecanvas gtksourceview;
    };
    lablgtk = callPackage ../development/ocaml-modules/lablgtk {
      inherit (pkgs.gnome2) libgnomecanvas gtksourceview;
    };

    lablgtk-extras =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/lablgtk-extras { }
      else callPackage ../development/ocaml-modules/lablgtk-extras/1.4.nix { };

    labltk = callPackage ../development/ocaml-modules/labltk { };

    lacaml = callPackage ../development/ocaml-modules/lacaml { };

    ladspa = callPackage ../development/ocaml-modules/ladspa { };

    lambdasoup = callPackage ../development/ocaml-modules/lambdasoup { };

    lambda-term = callPackage ../development/ocaml-modules/lambda-term { };

    lame = callPackage ../development/ocaml-modules/lame {
      inherit (pkgs) lame;
    };

    lastfm = callPackage ../development/ocaml-modules/lastfm { };

    lens = callPackage ../development/ocaml-modules/lens { };

    letsencrypt = callPackage ../development/ocaml-modules/letsencrypt { };

    letsencrypt-app = callPackage ../development/ocaml-modules/letsencrypt/app.nix { };

    letsencrypt-dns = callPackage ../development/ocaml-modules/letsencrypt/dns.nix { };

    lilv = callPackage ../development/ocaml-modules/lilv {
      inherit (pkgs) lilv;
    };

    linenoise = callPackage ../development/ocaml-modules/linenoise { };

    llvm = callPackage ../development/ocaml-modules/llvm {
      libllvm = pkgs.llvmPackages_10.libllvm;
    };

    lo = callPackage ../development/ocaml-modules/lo { };

    logs = callPackage ../development/ocaml-modules/logs { };

    lru = callPackage ../development/ocaml-modules/lru { };

    lua-ml = callPackage ../development/ocaml-modules/lua-ml { };

    lustre-v6 = callPackage ../development/ocaml-modules/lustre-v6 { };

    lutils = callPackage ../development/ocaml-modules/lutils { };

    luv = callPackage ../development/ocaml-modules/luv {
      inherit (pkgs) file;
    };

    lwt = callPackage ../development/ocaml-modules/lwt { };

    lwt-canceler = callPackage ../development/ocaml-modules/lwt-canceler { };

    ocaml_lwt = lwt;

    lwt_camlp4 = callPackage ../development/ocaml-modules/lwt/camlp4.nix { };

    lwt-dllist = callPackage ../development/ocaml-modules/lwt-dllist { };

    lwt-exit = callPackage ../development/ocaml-modules/lwt-exit { };

    lwt-watcher = callPackage ../development/ocaml-modules/lwt-watcher { };

    lwt_log = callPackage ../development/ocaml-modules/lwt_log { };

    lwt_ppx = callPackage ../development/ocaml-modules/lwt/ppx.nix { };

    lwt_react = callPackage ../development/ocaml-modules/lwt_react { };

    lwt_ssl = callPackage ../development/ocaml-modules/lwt_ssl { };

    macaddr = callPackage ../development/ocaml-modules/macaddr { };

    macaddr-cstruct = callPackage ../development/ocaml-modules/macaddr/cstruct.nix { };

    macaddr-sexp = callPackage ../development/ocaml-modules/macaddr/sexp.nix { };

    macaque = callPackage ../development/ocaml-modules/macaque { };

    mad = callPackage ../development/ocaml-modules/mad { };

    magic = callPackage ../development/ocaml-modules/magic { };

    magic-mime = callPackage ../development/ocaml-modules/magic-mime { };

    mariadb = callPackage ../development/ocaml-modules/mariadb {
      inherit (pkgs) mariadb;
    };

    markup = callPackage ../development/ocaml-modules/markup { };

    mccs = callPackage ../development/ocaml-modules/mccs { };

    mdx = callPackage ../development/ocaml-modules/mdx { };

    menhir = callPackage ../development/ocaml-modules/menhir { };

    menhirLib = callPackage ../development/ocaml-modules/menhir/lib.nix { };

    menhirSdk = callPackage ../development/ocaml-modules/menhir/sdk.nix { };

    merlin =
      if lib.versionAtLeast ocaml.version "4.12"
      then callPackage ../development/tools/ocaml/merlin/4.x.nix { }
      else callPackage ../development/tools/ocaml/merlin { };

    merlin-extend = callPackage ../development/ocaml-modules/merlin-extend { };

    merlin-lib = callPackage ../development/tools/ocaml/merlin/lib.nix { };

    dot-merlin-reader = callPackage ../development/tools/ocaml/merlin/dot-merlin-reader.nix { };

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

    mimic = callPackage ../development/ocaml-modules/mimic { };

    minisat = callPackage ../development/ocaml-modules/minisat { };

    mirage = callPackage ../development/ocaml-modules/mirage { };

    mirage-block = callPackage ../development/ocaml-modules/mirage-block { };

    mirage-block-combinators = callPackage ../development/ocaml-modules/mirage-block/combinators.nix { };

    mirage-block-ramdisk = callPackage ../development/ocaml-modules/mirage-block-ramdisk { };

    mirage-block-unix = callPackage ../development/ocaml-modules/mirage-block-unix { };

    mirage-bootvar-unix = callPackage ../development/ocaml-modules/mirage-bootvar-unix { };

    mirage-bootvar-xen = callPackage ../development/ocaml-modules/mirage-bootvar-xen { };

    mirage-channel = callPackage ../development/ocaml-modules/mirage-channel { };

    mirage-clock = callPackage ../development/ocaml-modules/mirage-clock { };

    mirage-clock-freestanding = callPackage ../development/ocaml-modules/mirage-clock/freestanding.nix { };

    mirage-clock-unix = callPackage ../development/ocaml-modules/mirage-clock/unix.nix { };

    mirage-console = callPackage ../development/ocaml-modules/mirage-console { };

    mirage-console-unix = callPackage ../development/ocaml-modules/mirage-console/unix.nix { };

    mirage-crypto = callPackage ../development/ocaml-modules/mirage-crypto { };

    mirage-crypto-ec = callPackage ../development/ocaml-modules/mirage-crypto/ec.nix { };

    mirage-crypto-pk = callPackage ../development/ocaml-modules/mirage-crypto/pk.nix { };

    mirage-crypto-rng = callPackage ../development/ocaml-modules/mirage-crypto/rng.nix { };

    mirage-crypto-rng-async = callPackage ../development/ocaml-modules/mirage-crypto/rng-async.nix { };

    mirage-crypto-rng-mirage = callPackage ../development/ocaml-modules/mirage-crypto/rng-mirage.nix { };

    mirage-device = callPackage ../development/ocaml-modules/mirage-device { };

    mirage-flow = callPackage ../development/ocaml-modules/mirage-flow { };

    mirage-flow-combinators = callPackage ../development/ocaml-modules/mirage-flow/combinators.nix { };

    mirage-flow-unix = callPackage ../development/ocaml-modules/mirage-flow/unix.nix { };

    mirage-fs = callPackage ../development/ocaml-modules/mirage-fs { };

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

    mirage-stack = callPackage ../development/ocaml-modules/mirage-stack { };

    mirage-time = callPackage ../development/ocaml-modules/mirage-time { };

    mirage-time-unix = callPackage ../development/ocaml-modules/mirage-time/unix.nix { };

    mirage-types = callPackage ../development/ocaml-modules/mirage/types.nix { };

    mirage-types-lwt = callPackage ../development/ocaml-modules/mirage/types-lwt.nix { };

    mirage-unix = callPackage ../development/ocaml-modules/mirage-unix { };

    mirage-xen = callPackage ../development/ocaml-modules/mirage-xen { };

    mirage-vnetif = callPackage ../development/ocaml-modules/mirage-vnetif { };

    mldoc =  callPackage ../development/ocaml-modules/mldoc { };

    mlgmp =  callPackage ../development/ocaml-modules/mlgmp { };

    mlgmpidl =  callPackage ../development/ocaml-modules/mlgmpidl { };

    mm = callPackage ../development/ocaml-modules/mm { };

    mmap =  callPackage ../development/ocaml-modules/mmap { };

    mparser =  callPackage ../development/ocaml-modules/mparser { };

    mparser-pcre =  callPackage ../development/ocaml-modules/mparser/pcre.nix { };

    mrmime = callPackage ../development/ocaml-modules/mrmime { };

    mtime =  callPackage ../development/ocaml-modules/mtime { };

    mustache =  callPackage ../development/ocaml-modules/mustache { };

    netchannel = callPackage ../development/ocaml-modules/netchannel { };

    nonstd =  callPackage ../development/ocaml-modules/nonstd { };

    notty = callPackage ../development/ocaml-modules/notty { };

    npy = callPackage ../development/ocaml-modules/npy {
      inherit (pkgs.python3Packages) numpy;
    };

    num = if lib.versionOlder "4.06" ocaml.version
      then callPackage ../development/ocaml-modules/num {}
      else null;

    parmap = callPackage ../development/ocaml-modules/parmap { };

    ocamlbuild =
    if lib.versionOlder "4.03" ocaml.version then
    callPackage ../development/tools/ocaml/ocamlbuild { }
    else
    null;

    ocaml_cryptgps = callPackage ../development/ocaml-modules/cryptgps { };

    ocaml_expat =
    if lib.versionAtLeast ocaml.version "4.02"
    then callPackage ../development/ocaml-modules/expat { }
    else callPackage ../development/ocaml-modules/expat/0.9.nix { };

    frontc = callPackage ../development/ocaml-modules/frontc { };

    ocamlformat-rpc-lib = callPackage ../development/ocaml-modules/ocamlformat-rpc-lib { };

    ocamlfuse = callPackage ../development/ocaml-modules/ocamlfuse { };

    ocaml-freestanding = callPackage ../development/ocaml-modules/ocaml-freestanding { };

    ocaml_gettext = callPackage ../development/ocaml-modules/ocaml-gettext { };

    gettext-camomile = callPackage ../development/ocaml-modules/ocaml-gettext/camomile.nix { };

    gettext-stub = callPackage ../development/ocaml-modules/ocaml-gettext/stub.nix { };

    ocamlgraph = callPackage ../development/ocaml-modules/ocamlgraph { };
    ocamlgraph_gtk = callPackage ../development/ocaml-modules/ocamlgraph/gtk.nix { };

    ocaml_libvirt = callPackage ../development/ocaml-modules/ocaml-libvirt { };

    ocamlify = callPackage ../development/tools/ocaml/ocamlify { };

    jsonrpc = callPackage ../development/ocaml-modules/ocaml-lsp/jsonrpc.nix { };
    lsp = callPackage ../development/ocaml-modules/ocaml-lsp/lsp.nix { };
    ocaml-lsp = callPackage ../development/ocaml-modules/ocaml-lsp { };

    ocaml-migrate-parsetree = ocaml-migrate-parsetree-1-8;

    ocaml-migrate-parsetree-1-8 = callPackage ../development/ocaml-modules/ocaml-migrate-parsetree/1.8.x.nix { };

    ocaml-migrate-parsetree-2 = callPackage ../development/ocaml-modules/ocaml-migrate-parsetree/2.x.nix { };

    ocamlmod = callPackage ../development/tools/ocaml/ocamlmod { };

    ocaml-monadic = callPackage ../development/ocaml-modules/ocaml-monadic { };

    ocaml_mysql = callPackage ../development/ocaml-modules/mysql { };

    ocamlnet = callPackage ../development/ocaml-modules/ocamlnet { };

    ocaml_oasis = callPackage ../development/tools/ocaml/oasis { };

    ocaml_pcre = callPackage ../development/ocaml-modules/pcre {};

    ocaml-print-intf = callPackage ../development/ocaml-modules/ocaml-print-intf { };

    ocaml-recovery-parser = callPackage ../development/tools/ocaml/ocaml-recovery-parser { };

    pgocaml = callPackage ../development/ocaml-modules/pgocaml {};

    pgocaml_ppx = callPackage ../development/ocaml-modules/pgocaml/ppx.nix {};

    ocaml-r = callPackage ../development/ocaml-modules/ocaml-r { };

    ocaml-sat-solvers = callPackage ../development/ocaml-modules/ocaml-sat-solvers { };

    ocamlscript = callPackage ../development/tools/ocaml/ocamlscript { };

    ocamlsdl= callPackage ../development/ocaml-modules/ocamlsdl { };

    ocaml_sqlite3 = callPackage ../development/ocaml-modules/sqlite3 { };

    ocaml-syntax-shims = callPackage ../development/ocaml-modules/ocaml-syntax-shims { };

    ocaml-vdom = callPackage ../development/ocaml-modules/ocaml-vdom { };

    syslog = callPackage ../development/ocaml-modules/syslog { };

    syslog-message = callPackage ../development/ocaml-modules/syslog-message { };

    ocaml-version = callPackage ../development/ocaml-modules/ocaml-version { };

    ocf = callPackage ../development/ocaml-modules/ocf { };

    ocf_ppx = callPackage ../development/ocaml-modules/ocf/ppx.nix { };

    ocp-build = callPackage ../development/tools/ocaml/ocp-build { };

    ocp-indent = callPackage ../development/tools/ocaml/ocp-indent { };

    ocp-index = callPackage ../development/tools/ocaml/ocp-index { };

    ocp-ocamlres = callPackage ../development/ocaml-modules/ocp-ocamlres { };

    ocplib-endian = callPackage ../development/ocaml-modules/ocplib-endian { };

    ocplib-json-typed = callPackage ../development/ocaml-modules/ocplib-json-typed { };

    ocplib-json-typed-browser = callPackage ../development/ocaml-modules/ocplib-json-typed/browser.nix { };

    ocplib-json-typed-bson = callPackage ../development/ocaml-modules/ocplib-json-typed/bson.nix { };

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

    odate = callPackage ../development/ocaml-modules/odate { };

    odoc = callPackage ../development/ocaml-modules/odoc { };

    odoc-parser = callPackage ../development/ocaml-modules/odoc-parser { };

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

    opium_kernel = callPackage ../development/ocaml-modules/opium_kernel { };

    opti = callPackage ../development/ocaml-modules/opti { };

    optint = callPackage ../development/ocaml-modules/optint { };

    opus = callPackage ../development/ocaml-modules/opus { };

    ordering = callPackage ../development/ocaml-modules/ordering { };

    otfm = callPackage ../development/ocaml-modules/otfm { };

    otoml = callPackage ../development/ocaml-modules/otoml { };

    otr = callPackage ../development/ocaml-modules/otr { };

    owee = callPackage ../development/ocaml-modules/owee { };

    owl-base = callPackage ../development/ocaml-modules/owl-base { };

    owl = callPackage ../development/ocaml-modules/owl { };

    ounit = callPackage ../development/ocaml-modules/ounit { };

    ounit2 = callPackage ../development/ocaml-modules/ounit2 { };

    paf = callPackage ../development/ocaml-modules/paf { };

    paf-cohttp = callPackage ../development/ocaml-modules/paf/cohttp.nix { };

    paf-le = callPackage ../development/ocaml-modules/paf/le.nix { };

    parse-argv = callPackage ../development/ocaml-modules/parse-argv { };

    path_glob = callPackage ../development/ocaml-modules/path_glob { };

    pbkdf = callPackage ../development/ocaml-modules/pbkdf { };

    pcap-format = callPackage ../development/ocaml-modules/pcap-format { };

    pecu = callPackage ../development/ocaml-modules/pecu { };

    pgsolver = callPackage ../development/ocaml-modules/pgsolver { };

    phylogenetics = callPackage ../development/ocaml-modules/phylogenetics { };

    piaf = callPackage ../development/ocaml-modules/piaf { };

    piqi = callPackage ../development/ocaml-modules/piqi { };

    piqi-ocaml = callPackage ../development/ocaml-modules/piqi-ocaml { };

    plotkicadsch = callPackage ../development/ocaml-modules/plotkicadsch {
      inherit (pkgs) coreutils imagemagick;
    };

    posix-base = callPackage ../development/ocaml-modules/posix/base.nix { };

    posix-socket = callPackage ../development/ocaml-modules/posix/socket.nix { };

    posix-time2 = callPackage ../development/ocaml-modules/posix/time2.nix { };

    posix-types = callPackage ../development/ocaml-modules/posix/types.nix { };

    postgresql = callPackage ../development/ocaml-modules/postgresql {
      inherit (pkgs) postgresql;
    };

    pp = callPackage ../development/ocaml-modules/pp { };

    ppx_bap = callPackage ../development/ocaml-modules/ppx_bap { };

    ppx_bitstring = callPackage ../development/ocaml-modules/bitstring/ppx.nix { };

    ppxlib = callPackage ../development/ocaml-modules/ppxlib { };

    psmt2-frontend = callPackage ../development/ocaml-modules/psmt2-frontend { };

    psq = callPackage ../development/ocaml-modules/psq { };

    ptime = callPackage ../development/ocaml-modules/ptime { };

    pulseaudio = callPackage ../development/ocaml-modules/pulseaudio {
      inherit (pkgs) pulseaudio;
    };

    pure-splitmix = callPackage ../development/ocaml-modules/pure-splitmix { };

    resource-pooling = callPackage ../development/ocaml-modules/resource-pooling { };

    repr = callPackage ../development/ocaml-modules/repr { };

    result = callPackage ../development/ocaml-modules/ocaml-result { };

    samplerate = callPackage ../development/ocaml-modules/samplerate { };

    secp256k1 = callPackage ../development/ocaml-modules/secp256k1 {
      inherit (pkgs) secp256k1;
    };

    secp256k1-internal = callPackage ../development/ocaml-modules/secp256k1-internal { };

    seq = callPackage ../development/ocaml-modules/seq { };

    shine = callPackage ../development/ocaml-modules/shine {
      inherit (pkgs) shine;
    };

    sosa = callPackage ../development/ocaml-modules/sosa { };

    soundtouch = callPackage ../development/ocaml-modules/soundtouch {
      inherit (pkgs) soundtouch;
    };

    spacetime_lib = callPackage ../development/ocaml-modules/spacetime_lib { };

    speex = callPackage ../development/ocaml-modules/speex {
      inherit (pkgs) speex;
    };

    tar-unix = callPackage ../development/ocaml-modules/tar/unix.nix { };

    tar = callPackage ../development/ocaml-modules/tar { };

    tcpip = callPackage ../development/ocaml-modules/tcpip { };

    tiny_httpd = callPackage ../development/ocaml-modules/tiny_httpd { };

    tsort = callPackage ../development/ocaml-modules/tsort { };

    tuntap = callPackage ../development/ocaml-modules/tuntap { };

    tyxml = callPackage ../development/ocaml-modules/tyxml { };

    ulex = callPackage ../development/ocaml-modules/ulex { };

    tls = callPackage ../development/ocaml-modules/tls { };

    tls-async = callPackage ../development/ocaml-modules/tls/async.nix { };

    tls-mirage = callPackage ../development/ocaml-modules/tls/mirage.nix { };

    torch = callPackage ../development/ocaml-modules/torch {
      inherit (pkgs.python3Packages) torch;
    };

    ocaml-protoc = callPackage ../development/ocaml-modules/ocaml-protoc { };

    ocaml_extlib = ocaml_extlib-1-7-8;

    ocaml_extlib-1-7-8 = callPackage ../development/ocaml-modules/extlib { };

    ocaml_extlib-1-7-7 = callPackage ../development/ocaml-modules/extlib/1.7.7.nix { };

    ocb-stubblr = callPackage ../development/ocaml-modules/ocb-stubblr { };

    ocurl = callPackage ../development/ocaml-modules/ocurl { };

    ogg = callPackage ../development/ocaml-modules/ogg { };

    parany = callPackage ../development/ocaml-modules/parany { };

    pipebang = callPackage ../development/ocaml-modules/pipebang { };

    portaudio = callPackage ../development/ocaml-modules/portaudio {
      inherit (pkgs) portaudio;
    };

    pprint = callPackage ../development/ocaml-modules/pprint { };

    ppx_blob = callPackage ../development/ocaml-modules/ppx_blob { };

    ppx_cstruct = callPackage ../development/ocaml-modules/cstruct/ppx.nix { };

    ppx_cstubs = callPackage ../development/ocaml-modules/ppx_cstubs { };

    ppx_derivers = callPackage ../development/ocaml-modules/ppx_derivers {};

    ppx_deriving = callPackage ../development/ocaml-modules/ppx_deriving {};

    ppx_deriving_protobuf = callPackage ../development/ocaml-modules/ppx_deriving_protobuf {};

    ppx_deriving_rpc = callPackage ../development/ocaml-modules/ppx_deriving_rpc { };

    ppx_deriving_yojson = callPackage ../development/ocaml-modules/ppx_deriving_yojson {};

    ppx_deriving_yaml = callPackage ../development/ocaml-modules/ppx_deriving_yaml {};

    ppx_deriving_cmdliner = callPackage ../development/ocaml-modules/ppx_deriving_cmdliner {};

    ppx_gen_rec = callPackage ../development/ocaml-modules/ppx_gen_rec {};

    ppx_import = callPackage ../development/ocaml-modules/ppx_import {};

    ppx_irmin = callPackage ../development/ocaml-modules/irmin/ppx.nix {
    };

    ppx_repr = callPackage ../development/ocaml-modules/repr/ppx.nix { };

    ppx_tools =
      if lib.versionAtLeast ocaml.version "4.02"
      then callPackage ../development/ocaml-modules/ppx_tools {}
      else null;

    ppx_tools_versioned = callPackage ../development/ocaml-modules/ppx_tools_versioned { };

    ppx_yojson_conv_lib = callPackage ../development/ocaml-modules/ppx_yojson_conv_lib {};

    prettym = callPackage ../development/ocaml-modules/prettym { };

    printbox = callPackage ../development/ocaml-modules/printbox { };

    printbox-text = callPackage ../development/ocaml-modules/printbox/text.nix { };

    process = callPackage ../development/ocaml-modules/process { };

    prof_spacetime = callPackage ../development/ocaml-modules/prof_spacetime { };

    progress = callPackage ../development/ocaml-modules/progress { };

    promise_jsoo = callPackage ../development/ocaml-modules/promise_jsoo { };

    ptmap = callPackage ../development/ocaml-modules/ptmap { };

    ptset = callPackage ../development/ocaml-modules/ptset { };

    pyml = callPackage ../development/ocaml-modules/pyml { };

    qcheck-alcotest = callPackage ../development/ocaml-modules/qcheck/alcotest.nix { };

    qcheck-core = callPackage ../development/ocaml-modules/qcheck/core.nix { };

    qcheck-ounit = callPackage ../development/ocaml-modules/qcheck/ounit.nix { };

    qcheck = callPackage ../development/ocaml-modules/qcheck { };

    qtest = callPackage ../development/ocaml-modules/qtest { };

    randomconv = callPackage ../development/ocaml-modules/randomconv { };

    rdbg = callPackage ../development/ocaml-modules/rdbg { };

    re = callPackage ../development/ocaml-modules/re { };

    react = callPackage ../development/ocaml-modules/react { };

    reactivedata = callPackage ../development/ocaml-modules/reactivedata {};

    reason = callPackage ../development/compilers/reason { };

    reason-native = lib.recurseIntoAttrs (callPackage ../development/ocaml-modules/reason-native { });

    rebez = callPackage ../development/ocaml-modules/rebez { };

    reperf = callPackage ../development/ocaml-modules/reperf { };

    rfc7748 = callPackage ../development/ocaml-modules/rfc7748 { };

    resto = callPackage ../development/ocaml-modules/resto { };
    resto-acl = callPackage ../development/ocaml-modules/resto/acl.nix { };
    resto-cohttp = callPackage ../development/ocaml-modules/resto/cohttp.nix { };
    resto-cohttp-client = callPackage ../development/ocaml-modules/resto/cohttp-client.nix { };
    resto-cohttp-self-serving-client = callPackage ../development/ocaml-modules/resto/cohttp-self-serving-client.nix { };
    resto-cohttp-server = callPackage ../development/ocaml-modules/resto/cohttp-server.nix { };
    resto-directory = callPackage ../development/ocaml-modules/resto/directory.nix { };
    resto-json = callPackage ../development/ocaml-modules/resto/json.nix { };

    ringo = callPackage ../development/ocaml-modules/ringo { };
    ringo-lwt = callPackage ../development/ocaml-modules/ringo/lwt.nix { };

    rope = callPackage ../development/ocaml-modules/rope { };

    rosetta = callPackage ../development/ocaml-modules/rosetta { };

    routes = callPackage ../development/ocaml-modules/routes { };

    rpclib = callPackage ../development/ocaml-modules/rpclib { };

    rpclib-lwt = callPackage ../development/ocaml-modules/rpclib/lwt.nix { };

    rresult = callPackage ../development/ocaml-modules/rresult { };

    safepass = callPackage ../development/ocaml-modules/safepass { };

    sedlex = callPackage ../development/ocaml-modules/sedlex { };

    semaphore-compat = callPackage ../development/ocaml-modules/semaphore-compat { };

    sha = callPackage ../development/ocaml-modules/sha { };

    shared-memory-ring = callPackage ../development/ocaml-modules/shared-memory-ring { };

    shared-memory-ring-lwt = callPackage ../development/ocaml-modules/shared-memory-ring/lwt.nix { };

    sodium = callPackage ../development/ocaml-modules/sodium { };

    spelll = callPackage ../development/ocaml-modules/spelll { };

    srt = callPackage ../development/ocaml-modules/srt {
      inherit (pkgs) srt;
    };

    ssl = callPackage ../development/ocaml-modules/ssl { };

    stdcompat = callPackage ../development/ocaml-modules/stdcompat { };

    stdlib-shims = callPackage ../development/ocaml-modules/stdlib-shims { };

    stdune = callPackage ../development/ocaml-modules/stdune { };

    stog = callPackage ../applications/misc/stog { };

    stringext = callPackage ../development/ocaml-modules/stringext { };

    taglib = callPackage ../development/ocaml-modules/taglib {
      inherit (pkgs) taglib;
    };

    tcslib = callPackage ../development/ocaml-modules/tcslib { };

    telegraml = callPackage ../development/ocaml-modules/telegraml { };

    terminal = callPackage ../development/ocaml-modules/terminal { };

    terminal_size = callPackage ../development/ocaml-modules/terminal_size { };

    theora = callPackage ../development/ocaml-modules/theora { };

    toml = callPackage ../development/ocaml-modules/toml { };

    topkg = callPackage ../development/ocaml-modules/topkg { };

    trie = callPackage ../development/ocaml-modules/trie { };

    tsdl = callPackage ../development/ocaml-modules/tsdl { };

    tsdl-image = callPackage ../development/ocaml-modules/tsdl-image { };

    tsdl-mixer = callPackage ../development/ocaml-modules/tsdl-mixer { };

    tsdl-ttf = callPackage ../development/ocaml-modules/tsdl-ttf { };

    twt = callPackage ../development/ocaml-modules/twt { };

    uchar = callPackage ../development/ocaml-modules/uchar { };

    uecc = callPackage ../development/ocaml-modules/uecc { };

    unix-errno = callPackage ../development/ocaml-modules/unix-errno { };

    utop = callPackage ../development/tools/ocaml/utop { };

    uuidm = callPackage ../development/ocaml-modules/uuidm { };

    sawja = callPackage ../development/ocaml-modules/sawja { };

    stdint = callPackage ../development/ocaml-modules/stdint { };

    unionFind = callPackage ../development/ocaml-modules/unionFind { };

    unstrctrd = callPackage ../development/ocaml-modules/unstrctrd { };

    uucd = callPackage ../development/ocaml-modules/uucd { };
    uucp = callPackage ../development/ocaml-modules/uucp { };
    uunf = callPackage ../development/ocaml-modules/uunf { };

    uri = callPackage ../development/ocaml-modules/uri { };

    uri-sexp = callPackage ../development/ocaml-modules/uri/sexp.nix { };

    uuseg = callPackage ../development/ocaml-modules/uuseg { };
    uutf = callPackage ../development/ocaml-modules/uutf { };

    uuuu = callPackage ../development/ocaml-modules/uuuu { };

    vchan = callPackage ../development/ocaml-modules/vchan { };

    vector = callPackage ../development/ocaml-modules/vector { };

    vg = callPackage ../development/ocaml-modules/vg { };

    vlq = callPackage ../development/ocaml-modules/vlq { };

    vorbis = callPackage ../development/ocaml-modules/vorbis { };

    visitors = callPackage ../development/ocaml-modules/visitors { };

    wasm = callPackage ../development/ocaml-modules/wasm { };

    wayland = callPackage ../development/ocaml-modules/wayland { };

    webbrowser = callPackage ../development/ocaml-modules/webbrowser { };

    webmachine = callPackage ../development/ocaml-modules/webmachine { };

    wodan = callPackage ../development/ocaml-modules/wodan { };

    wodan-irmin = callPackage ../development/ocaml-modules/wodan/irmin.nix { };

    wodan-unix = callPackage ../development/ocaml-modules/wodan/unix.nix { };

    wtf8 = callPackage ../development/ocaml-modules/wtf8 { };

    x509 = callPackage ../development/ocaml-modules/x509 { };

    xdg = callPackage ../development/ocaml-modules/xdg { };

    xenstore = callPackage ../development/ocaml-modules/xenstore { };

    xenstore_transport = callPackage ../development/ocaml-modules/xenstore_transport { };

    xenstore-tool = callPackage ../development/ocaml-modules/xenstore-tool { };

    xmlm = callPackage ../development/ocaml-modules/xmlm { };

    xmlplaylist = callPackage ../development/ocaml-modules/xmlplaylist { };

    xml-light = callPackage ../development/ocaml-modules/xml-light { };

    xtmpl = callPackage ../development/ocaml-modules/xtmpl { };

    xtmpl_ppx = callPackage ../development/ocaml-modules/xtmpl/ppx.nix { };

    yaml = callPackage ../development/ocaml-modules/yaml { };

    yaml-sexp = callPackage ../development/ocaml-modules/yaml/yaml-sexp.nix { };

    yojson = callPackage ../development/ocaml-modules/yojson { };

    yuscii = callPackage ../development/ocaml-modules/yuscii { };

    yuujinchou = callPackage ../development/ocaml-modules/yuujinchou { };

    z3 = callPackage ../development/ocaml-modules/z3 {
      inherit (pkgs) z3;
    };

    zarith = callPackage ../development/ocaml-modules/zarith { };

    zed = callPackage ../development/ocaml-modules/zed { };

    zmq = callPackage ../development/ocaml-modules/zmq { };

    zmq-lwt = callPackage ../development/ocaml-modules/zmq/lwt.nix { };

    ocsigen_deriving = callPackage ../development/ocaml-modules/ocsigen-deriving {
      oasis = ocaml_oasis;
    };

    # Jane Street

    janePackage =
      if lib.versionOlder "4.10.2" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/janePackage_0_15.nix {}
      else if lib.versionOlder "4.08" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/janePackage_0_14.nix {}
      else if lib.versionOlder "4.07" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/janePackage_0_12.nix {}
      else callPackage ../development/ocaml-modules/janestreet/janePackage.nix {};

    janeStreet =
    if lib.versionOlder "4.10.2" ocaml.version
    then import ../development/ocaml-modules/janestreet/0.15.nix {
      inherit self;
      inherit (pkgs) fetchpatch lib openssl zstd;
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
      self = self // {
        ppxlib = ppxlib.override { version = "0.8.1"; };
      };
      inherit (pkgs) openssl;
    };

    janeStreet_0_9_0 = import ../development/ocaml-modules/janestreet/old.nix {
      self = self.janeStreet_0_9_0;
      super = self // {
        janePackage = callPackage ../development/ocaml-modules/janestreet/janePackage.nix {
          defaultVersion = "0.9.0";
        };
      };
      inherit (pkgs) stdenv lib openssl;
    };

    # Apps / from all-packages

    ocamlnat = callPackage  ../development/ocaml-modules/ocamlnat { };

    omake_rc1 = callPackage ../development/tools/ocaml/omake/0.9.8.6-rc1.nix { };

    google-drive-ocamlfuse = callPackage ../applications/networking/google-drive-ocamlfuse {
      # needs Base64 module
      ocaml_extlib = ocaml_extlib.override { minimal = false; };
    };

    hol_light = callPackage ../applications/science/logic/hol_light { };

  })).overrideScope' liftJaneStreet;

in let inherit (pkgs) callPackage; in rec
{

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

  ocamlPackages_latest = ocamlPackages_4_14;

  ocamlPackages = ocamlPackages_4_14;
}
