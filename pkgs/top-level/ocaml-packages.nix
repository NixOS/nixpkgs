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

    buildDune2Package = buildDunePackage.override { dune = dune_2; };

    alcotest = callPackage ../development/ocaml-modules/alcotest {};

    alcotest-lwt = callPackage ../development/ocaml-modules/alcotest/lwt.nix {};

    angstrom = callPackage ../development/ocaml-modules/angstrom { };

    angstrom-async = callPackage ../development/ocaml-modules/angstrom-async { };

    angstrom-lwt-unix = callPackage ../development/ocaml-modules/angstrom-lwt-unix { };

    angstrom-unix = callPackage ../development/ocaml-modules/angstrom-unix { };

    ansiterminal = callPackage ../development/ocaml-modules/ansiterminal { };

    apron = callPackage ../development/ocaml-modules/apron { };

    asn1-combinators = callPackage ../development/ocaml-modules/asn1-combinators { };

    astring = callPackage ../development/ocaml-modules/astring { };

    async_extra_p4 = callPackage ../development/ocaml-modules/async_extra { };

    async_find =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.async_find
      else callPackage ../development/ocaml-modules/async_find { };

    async_kernel_p4 = callPackage ../development/ocaml-modules/async_kernel { };

    async_shell =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.async_shell
      else callPackage ../development/ocaml-modules/async_shell { };

    async_unix_p4 = callPackage ../development/ocaml-modules/async_unix { };

    async_p4 =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/async { }
      else null;

    atd = callPackage ../development/ocaml-modules/atd { };

    atdgen = callPackage ../development/ocaml-modules/atdgen { };

    base64_2 = callPackage ../development/ocaml-modules/base64/2.0.nix { };

    base64 = callPackage ../development/ocaml-modules/base64 { };

    bap = callPackage ../development/ocaml-modules/bap {
      llvm = pkgs.llvm_8;
    };

    batteries = callPackage ../development/ocaml-modules/batteries { };

    bigarray-compat = callPackage ../development/ocaml-modules/bigarray-compat { };

    bigstringaf = callPackage ../development/ocaml-modules/bigstringaf { };

    biocaml = callPackage ../development/ocaml-modules/biocaml { };

    bistro = callPackage ../development/ocaml-modules/bistro { };

    bitstring = callPackage ../development/ocaml-modules/bitstring { };

    bitv = callPackage ../development/ocaml-modules/bitv { };

    bolt = callPackage ../development/ocaml-modules/bolt { };

    bos = callPackage ../development/ocaml-modules/bos { };

    camlidl = callPackage ../development/tools/ocaml/camlidl { };

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

    camlimages_4_0 =
      if lib.versionOlder "4.02" ocaml.version
      then null
      else callPackage ../development/ocaml-modules/camlimages/4.0.nix {
      libpng = pkgs.libpng12;
      giflib = pkgs.giflib_4_1;
    };
    camlimages_4_1 = callPackage ../development/ocaml-modules/camlimages/4.1.nix {
      giflib = pkgs.giflib_4_1;
    };
    camlimages =
          if lib.versionOlder "4.06" ocaml.version
          then callPackage ../development/ocaml-modules/camlimages { }
          else camlimages_4_1;

    benchmark = callPackage ../development/ocaml-modules/benchmark { };

    biniou =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/biniou { }
      else callPackage ../development/ocaml-modules/biniou/1.0.nix { };

    bin_prot_p4 = callPackage ../development/ocaml-modules/bin_prot { };

    bisect_ppx = callPackage ../development/ocaml-modules/bisect_ppx { };
    bisect_ppx-ocamlbuild = callPackage ../development/ocaml-modules/bisect_ppx-ocamlbuild { };

    ocaml_cairo = callPackage ../development/ocaml-modules/ocaml-cairo { };

    cairo2 = callPackage ../development/ocaml-modules/cairo2 { };

    cfstream = callPackage ../development/ocaml-modules/cfstream { };

    charInfo_width = callPackage ../development/ocaml-modules/charInfo_width { };

    checkseum = callPackage ../development/ocaml-modules/checkseum { };

    cil = callPackage ../development/ocaml-modules/cil { };

    cmdliner = callPackage ../development/ocaml-modules/cmdliner { };

    cohttp_p4 = callPackage ../development/ocaml-modules/cohttp/0.19.3.nix {
      base64 = base64_2;
      lwt = lwt2;
    };

    cohttp =
      if lib.versionOlder "4.03" ocaml.version
      then callPackage ../development/ocaml-modules/cohttp { }
      else cohttp_p4;

    cohttp-lwt = callPackage ../development/ocaml-modules/cohttp/lwt.nix { };

    cohttp-lwt-unix = callPackage ../development/ocaml-modules/cohttp/lwt-unix.nix { };

    conduit_p4 = callPackage ../development/ocaml-modules/conduit/0.10.0.nix {
       lwt = lwt2;
    };

    conduit =
      if lib.versionOlder "4.03" ocaml.version
      then callPackage ../development/ocaml-modules/conduit { }
      else conduit_p4;

    conduit-lwt = callPackage ../development/ocaml-modules/conduit/lwt.nix { };

    conduit-lwt-unix = callPackage ../development/ocaml-modules/conduit/lwt-unix.nix { };

    config-file = callPackage ../development/ocaml-modules/config-file { };

    containers = callPackage ../development/ocaml-modules/containers { };

    cow = callPackage ../development/ocaml-modules/cow { };

    cpdf = callPackage ../development/ocaml-modules/cpdf { };

    cppo = callPackage ../development/tools/ocaml/cppo { };

    cpu = callPackage ../development/ocaml-modules/cpu { };

    cpuid = callPackage ../development/ocaml-modules/cpuid { };

    crunch = callPackage ../development/tools/ocaml/crunch { };

    cryptokit = callPackage ../development/ocaml-modules/cryptokit { };

    cstruct =
      if lib.versionAtLeast ocaml.version "4.2"
      then callPackage ../development/ocaml-modules/cstruct {}
      else callPackage ../development/ocaml-modules/cstruct/1.9.0.nix { lwt = ocaml_lwt; };

    cstruct-lwt = callPackage ../development/ocaml-modules/cstruct/lwt.nix {
      lwt = ocaml_lwt;
    };

    cstruct-sexp = callPackage ../development/ocaml-modules/cstruct/sexp.nix {};

    cstruct-unix = callPackage ../development/ocaml-modules/cstruct/unix.nix {};

    csv =
      if lib.versionAtLeast ocaml.version "4.2"
      then callPackage ../development/ocaml-modules/csv { }
      else callPackage ../development/ocaml-modules/csv/1.5.nix { };

    csv-lwt = callPackage ../development/ocaml-modules/csv/lwt.nix { };

    curses = callPackage ../development/ocaml-modules/curses { };

    custom_printf = callPackage ../development/ocaml-modules/custom_printf { };

    ctypes = callPackage ../development/ocaml-modules/ctypes { };

    decompress =  callPackage ../development/ocaml-modules/decompress { };

    digestif =  callPackage ../development/ocaml-modules/digestif { };

    dispatch =  callPackage ../development/ocaml-modules/dispatch { };

    dolmen =  callPackage ../development/ocaml-modules/dolmen { };

    dolog = callPackage ../development/ocaml-modules/dolog { };

    domain-name = callPackage ../development/ocaml-modules/domain-name { };

    dtoa = callPackage ../development/ocaml-modules/dtoa { };

    duff = callPackage ../development/ocaml-modules/duff { };

    dune = callPackage ../development/tools/ocaml/dune { };

    dune_2 = callPackage ../development/tools/ocaml/dune/2.nix { };

    dune-configurator = callPackage ../development/ocaml-modules/dune-configurator { buildDunePackage = buildDune2Package; };

    dune-private-libs = callPackage ../development/ocaml-modules/dune-private-libs { buildDunePackage = buildDune2Package; };

    earley = callPackage ../development/ocaml-modules/earley { };

    earlybird = callPackage ../development/ocaml-modules/earlybird { };

    easy-format = callPackage ../development/ocaml-modules/easy-format { };

    eigen = callPackage ../development/ocaml-modules/eigen { };

    elina = callPackage ../development/ocaml-modules/elina { };

    eliom = callPackage ../development/ocaml-modules/eliom { };

    elpi = callPackage ../development/ocaml-modules/elpi { };

    encore = callPackage ../development/ocaml-modules/encore { };

    enumerate = callPackage ../development/ocaml-modules/enumerate { };

    eqaf = callPackage ../development/ocaml-modules/eqaf { };

    erm_xml = callPackage ../development/ocaml-modules/erm_xml { };

    erm_xmpp = callPackage ../development/ocaml-modules/erm_xmpp { };

    estring = callPackage ../development/ocaml-modules/estring { };

    ezjsonm = callPackage ../development/ocaml-modules/ezjsonm { };

    ezxmlm = callPackage ../development/ocaml-modules/ezxmlm { };

    facile = callPackage ../development/ocaml-modules/facile { };

    faillib = callPackage ../development/ocaml-modules/faillib { };

    faraday = callPackage ../development/ocaml-modules/faraday { };

    farfadet = callPackage ../development/ocaml-modules/farfadet { };

    fieldslib_p4 = callPackage ../development/ocaml-modules/fieldslib { };

    fileutils = callPackage ../development/ocaml-modules/fileutils { };

    findlib = callPackage ../development/tools/ocaml/findlib { };

    fix = callPackage ../development/ocaml-modules/fix { };

    fmt = callPackage ../development/ocaml-modules/fmt { };

    fontconfig = callPackage ../development/ocaml-modules/fontconfig {
      inherit (pkgs) fontconfig;
    };

    fpath = callPackage ../development/ocaml-modules/fpath { };

    functoria = callPackage ../development/ocaml-modules/functoria { };

    functory = callPackage ../development/ocaml-modules/functory { };

    gen = callPackage ../development/ocaml-modules/gen { };

    gmap = callPackage ../development/ocaml-modules/gmap { };

    gnuplot = callPackage ../development/ocaml-modules/gnuplot {
      inherit (pkgs) gnuplot;
    };

    herelib = callPackage ../development/ocaml-modules/herelib { };

    higlo = callPackage ../development/ocaml-modules/higlo { };

    hmap = callPackage ../development/ocaml-modules/hmap { };

    imagelib = callPackage ../development/ocaml-modules/imagelib { };

    imagelib-unix = callPackage ../development/ocaml-modules/imagelib/unix.nix { };

    inotify = callPackage ../development/ocaml-modules/inotify { };

    integers = callPackage ../development/ocaml-modules/integers { };

    io-page = callPackage ../development/ocaml-modules/io-page { };

    ipaddr_p4 = callPackage ../development/ocaml-modules/ipaddr/2.6.1.nix { };

    ipaddr =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/ipaddr { }
      else ipaddr_p4;

    irmin_1 = callPackage ../development/ocaml-modules/irmin/1.4.nix { };

    iso8601 = callPackage ../development/ocaml-modules/iso8601 { };

    iter = callPackage ../development/ocaml-modules/iter { };

    javalib = callPackage ../development/ocaml-modules/javalib {
      extlib = ocaml_extlib;
    };

    dypgen = callPackage ../development/ocaml-modules/dypgen { };

    gapi_ocaml = callPackage ../development/ocaml-modules/gapi-ocaml { };

    gg = callPackage ../development/ocaml-modules/gg { };

    git = callPackage ../development/ocaml-modules/git { inherit (pkgs) git; };

    git-http = callPackage ../development/ocaml-modules/git-http { };

    git-unix = callPackage ../development/ocaml-modules/git-unix { };

    gmetadom = callPackage ../development/ocaml-modules/gmetadom { };

    graphql = callPackage ../development/ocaml-modules/graphql { };

    graphql-cohttp = callPackage ../development/ocaml-modules/graphql/cohttp.nix { };

    graphql-lwt = callPackage ../development/ocaml-modules/graphql/lwt.nix { };

    graphql_parser = callPackage ../development/ocaml-modules/graphql/parser.nix { };

    gtktop = callPackage ../development/ocaml-modules/gtktop { };

    hex = callPackage ../development/ocaml-modules/hex { };

    httpaf = callPackage ../development/ocaml-modules/httpaf { };

    index = callPackage ../development/ocaml-modules/index { };

    inifiles = callPackage ../development/ocaml-modules/inifiles { };

    iri = callPackage ../development/ocaml-modules/iri { };

    irmin = callPackage ../development/ocaml-modules/irmin { };

    irmin-fs = callPackage ../development/ocaml-modules/irmin/fs.nix { };

    irmin-git = callPackage ../development/ocaml-modules/irmin/git.nix { };

    irmin-graphql = callPackage ../development/ocaml-modules/irmin/graphql.nix { };

    irmin-http = callPackage ../development/ocaml-modules/irmin/http.nix { };

    irmin-mem = callPackage ../development/ocaml-modules/irmin/mem.nix { };

    irmin-pack = callPackage ../development/ocaml-modules/irmin/pack.nix { };

    irmin-test = callPackage ../development/ocaml-modules/irmin/test.nix { };

    irmin-unix = callPackage ../development/ocaml-modules/irmin/unix.nix { };

    irmin-watcher = callPackage ../development/ocaml-modules/irmin-watcher { };

    jingoo = callPackage ../development/ocaml-modules/jingoo {
      pcre = ocaml_pcre;
    };

    js_of_ocaml =
    if lib.versionOlder "4.02" ocaml.version
    then callPackage ../development/tools/ocaml/js_of_ocaml/3.0.nix { }
    else js_of_ocaml_2;

    js_of_ocaml_2 = callPackage ../development/tools/ocaml/js_of_ocaml {
      base64 = base64_2;
      lwt = lwt2;
    };

    js_of_ocaml-camlp4 = callPackage ../development/tools/ocaml/js_of_ocaml/camlp4.nix {};

    js_of_ocaml-compiler = callPackage ../development/tools/ocaml/js_of_ocaml/compiler.nix {};

    js_of_ocaml-lwt = callPackage ../development/tools/ocaml/js_of_ocaml/lwt.nix {};

    js_of_ocaml-ocamlbuild = callPackage ../development/tools/ocaml/js_of_ocaml/ocamlbuild.nix {};

    js_of_ocaml-ppx = callPackage ../development/tools/ocaml/js_of_ocaml/ppx.nix {};

    js_of_ocaml-ppx_deriving_json = callPackage ../development/tools/ocaml/js_of_ocaml/ppx_deriving_json.nix {};

    js_of_ocaml-tyxml = callPackage ../development/tools/ocaml/js_of_ocaml/tyxml.nix {};

    jsonm = callPackage ../development/ocaml-modules/jsonm { };

    kafka = callPackage ../development/ocaml-modules/kafka { };

    ke = callPackage ../development/ocaml-modules/ke { };

    lablgl = callPackage ../development/ocaml-modules/lablgl { };

    lablgtk3 = callPackage ../development/ocaml-modules/lablgtk3 { };

    lablgtk3-gtkspell3 = callPackage ../development/ocaml-modules/lablgtk3/gtkspell3.nix { };

    lablgtk3-sourceview3 = callPackage ../development/ocaml-modules/lablgtk3/sourceview3.nix { };

    lablgtk_2_14 = callPackage ../development/ocaml-modules/lablgtk/2.14.0.nix {
      inherit (pkgs.gnome2) libgnomecanvas libglade gtksourceview;
    };
    lablgtk = callPackage ../development/ocaml-modules/lablgtk {
      inherit (pkgs.gnome2) libgnomecanvas libglade gtksourceview;
    };

    lablgtk-extras =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/lablgtk-extras { }
      else callPackage ../development/ocaml-modules/lablgtk-extras/1.4.nix { };

    lablgtkmathview = callPackage ../development/ocaml-modules/lablgtkmathview {
      gtkmathview = callPackage ../development/libraries/gtkmathview { };
    };

    labltk = callPackage ../development/ocaml-modules/labltk { };

    lacaml = callPackage ../development/ocaml-modules/lacaml { };

    lambdasoup = callPackage ../development/ocaml-modules/lambdasoup { };

    lambdaTerm = callPackage ../development/ocaml-modules/lambda-term { };

    lens = callPackage ../development/ocaml-modules/lens { };

    linenoise = callPackage ../development/ocaml-modules/linenoise { };

    llvm = callPackage ../development/ocaml-modules/llvm {
      llvm = pkgs.llvm_8;
    };

    logs = callPackage ../development/ocaml-modules/logs {
      lwt = ocaml_lwt;
    };

    lru = callPackage ../development/ocaml-modules/lru { };

    lua-ml = callPackage ../development/ocaml-modules/lua-ml { };

    lwt2 = callPackage ../development/ocaml-modules/lwt/legacy.nix { };

    lwt4 = callPackage ../development/ocaml-modules/lwt/4.x.nix { };

    ocaml_lwt = if lib.versionOlder "4.02" ocaml.version then lwt4 else lwt2;

    lwt_camlp4 = callPackage ../development/ocaml-modules/lwt/camlp4.nix { };

    lwt_log = callPackage ../development/ocaml-modules/lwt_log {
      lwt = lwt4;
    };

    lwt_ppx = callPackage ../development/ocaml-modules/lwt/ppx.nix {
      lwt = ocaml_lwt;
    };

    lwt_react = callPackage ../development/ocaml-modules/lwt_react {
      lwt = ocaml_lwt;
    };

    lwt_ssl = callPackage ../development/ocaml-modules/lwt_ssl {
      lwt = ocaml_lwt;
    };

    macaddr = callPackage ../development/ocaml-modules/macaddr { };

    macaque = callPackage ../development/ocaml-modules/macaque { };

    magic-mime = callPackage ../development/ocaml-modules/magic-mime { };

    magick = callPackage ../development/ocaml-modules/magick { };

    markup = callPackage ../development/ocaml-modules/markup { lwt = ocaml_lwt; };

    mdx = callPackage ../development/ocaml-modules/mdx { };

    menhir = callPackage ../development/ocaml-modules/menhir { };

    merlin = callPackage ../development/tools/ocaml/merlin { };

    merlin-extend = callPackage ../development/ocaml-modules/merlin-extend { };

    metrics = callPackage ../development/ocaml-modules/metrics { };

    metrics-lwt = callPackage ../development/ocaml-modules/metrics/lwt.nix { };

    metrics-unix = callPackage ../development/ocaml-modules/metrics/unix.nix {
      inherit (pkgs) gnuplot;
    };

    mezzo = callPackage ../development/compilers/mezzo { };

    minisat = callPackage ../development/ocaml-modules/minisat { };

    mlgmp =  callPackage ../development/ocaml-modules/mlgmp { };

    mlgmpidl =  callPackage ../development/ocaml-modules/mlgmpidl { };

    mmap =  callPackage ../development/ocaml-modules/mmap { };

    mparser =  callPackage ../development/ocaml-modules/mparser { };

    mstruct =  callPackage ../development/ocaml-modules/mstruct { };

    mtime =  callPackage ../development/ocaml-modules/mtime { };

    nocrypto =  callPackage ../development/ocaml-modules/nocrypto { };

    notty = callPackage ../development/ocaml-modules/notty {
      lwt = ocaml_lwt;
    };

    num = if lib.versionOlder "4.06" ocaml.version
      then callPackage ../development/ocaml-modules/num {}
      else null;

    comparelib = callPackage ../development/ocaml-modules/comparelib { };

    core_extended_p4 = callPackage ../development/ocaml-modules/core_extended { };

    core_kernel_p4 = callPackage ../development/ocaml-modules/core_kernel { };

    core_p4 = callPackage ../development/ocaml-modules/core { };

    ocamlbuild =
    if lib.versionOlder "4.03" ocaml.version then
    callPackage ../development/tools/ocaml/ocamlbuild { }
    else
    null;

    ocaml_cryptgps = callPackage ../development/ocaml-modules/cryptgps { };

    ocaml_data_notation = callPackage ../development/ocaml-modules/odn { };

    ocaml_expat =
    if lib.versionAtLeast ocaml.version "4.02"
    then callPackage ../development/ocaml-modules/expat { }
    else callPackage ../development/ocaml-modules/expat/0.9.nix { };

    frontc = callPackage ../development/ocaml-modules/frontc { };

    ocamlfuse = callPackage ../development/ocaml-modules/ocamlfuse { };

    ocaml_gettext = callPackage ../development/ocaml-modules/ocaml-gettext { };

    ocamlgraph = callPackage ../development/ocaml-modules/ocamlgraph { };

    ocaml_http = callPackage ../development/ocaml-modules/http { };

    ocaml_libvirt = callPackage ../development/ocaml-modules/ocaml-libvirt { };

    ocamlify = callPackage ../development/tools/ocaml/ocamlify { };

    ocaml-migrate-parsetree = callPackage ../development/ocaml-modules/ocaml-migrate-parsetree { };

    ocamlmod = callPackage ../development/tools/ocaml/ocamlmod { };

    ocaml-monadic = callPackage ../development/ocaml-modules/ocaml-monadic { };

    ocaml_mysql = callPackage ../development/ocaml-modules/mysql { };

    ocamlnet = callPackage ../development/ocaml-modules/ocamlnet { };

    ocaml_oasis = callPackage ../development/tools/ocaml/oasis { };

    ocaml_optcomp = callPackage ../development/ocaml-modules/optcomp { };

    ocaml_pcre = callPackage ../development/ocaml-modules/pcre {};

    pgocaml = callPackage ../development/ocaml-modules/pgocaml {};

    ocaml-sat-solvers = callPackage ../development/ocaml-modules/ocaml-sat-solvers { };

    ocamlscript = callPackage ../development/tools/ocaml/ocamlscript { };

    ocamlsdl= callPackage ../development/ocaml-modules/ocamlsdl { };

    ocaml_sqlite3 = callPackage ../development/ocaml-modules/sqlite3 { };

    syslog = callPackage ../development/ocaml-modules/syslog { };

    ocaml_text = callPackage ../development/ocaml-modules/ocaml-text { };

    ocaml-version = callPackage ../development/ocaml-modules/ocaml-version { };

    ocf = callPackage ../development/ocaml-modules/ocf { };

    ocp-build = callPackage ../development/tools/ocaml/ocp-build { };

    ocp-indent = callPackage ../development/tools/ocaml/ocp-indent { };

    ocp-index = callPackage ../development/tools/ocaml/ocp-index { };

    ocp-ocamlres = callPackage ../development/ocaml-modules/ocp-ocamlres { };

    ocplib-endian = callPackage ../development/ocaml-modules/ocplib-endian { };

    ocplib-json-typed = callPackage ../development/ocaml-modules/ocplib-json-typed { };

    ocplib-json-typed-browser = callPackage ../development/ocaml-modules/ocplib-json-typed/browser.nix { };

    ocplib-json-typed-bson = callPackage ../development/ocaml-modules/ocplib-json-typed/bson.nix { };

    ocplib-simplex = callPackage ../development/ocaml-modules/ocplib-simplex { };

    ocsigen_server = callPackage ../development/ocaml-modules/ocsigen-server { };

    ocsigen-start = callPackage ../development/ocaml-modules/ocsigen-start { };

    ocsigen-toolkit = callPackage ../development/ocaml-modules/ocsigen-toolkit { };

    octavius = callPackage ../development/ocaml-modules/octavius { };

    odoc = callPackage ../development/ocaml-modules/odoc { };

    omd = callPackage ../development/ocaml-modules/omd { };

    opam-file-format = callPackage ../development/ocaml-modules/opam-file-format { };

    opium = callPackage ../development/ocaml-modules/opium { };

    opium_kernel = callPackage ../development/ocaml-modules/opium_kernel { };

    opti = callPackage ../development/ocaml-modules/opti { };

    optint = callPackage ../development/ocaml-modules/optint { };

    otfm = callPackage ../development/ocaml-modules/otfm { };

    otr = callPackage ../development/ocaml-modules/otr { };

    owee = callPackage ../development/ocaml-modules/owee { };

    owl-base = callPackage ../development/ocaml-modules/owl-base { };

    owl = callPackage ../development/ocaml-modules/owl { };

    ounit = callPackage ../development/ocaml-modules/ounit { };

    pgsolver = callPackage ../development/ocaml-modules/pgsolver { };

    phylogenetics = callPackage ../development/ocaml-modules/phylogenetics { };

    piqi = callPackage ../development/ocaml-modules/piqi {
      base64 = base64_2;
    };

    piqi-ocaml = callPackage ../development/ocaml-modules/piqi-ocaml { };

    ppxfind = callPackage ../development/ocaml-modules/ppxfind { };

    ppxlib = callPackage ../development/ocaml-modules/ppxlib { };

    psmt2-frontend = callPackage ../development/ocaml-modules/psmt2-frontend { };

    psq = callPackage ../development/ocaml-modules/psq { };

    ptime = callPackage ../development/ocaml-modules/ptime { };

    re2_p4 = callPackage ../development/ocaml-modules/re2 { };

    resource-pooling = callPackage ../development/ocaml-modules/resource-pooling { };

    result = callPackage ../development/ocaml-modules/ocaml-result { };

    secp256k1 = callPackage ../development/ocaml-modules/secp256k1 {
      inherit (pkgs) secp256k1;
    };

    seq = callPackage ../development/ocaml-modules/seq { };

    spacetime_lib = callPackage ../development/ocaml-modules/spacetime_lib { };

    sqlexpr = callPackage ../development/ocaml-modules/sqlexpr { };

    tuntap = callPackage ../development/ocaml-modules/tuntap { };

    tyxml = callPackage ../development/ocaml-modules/tyxml { };

    ulex = callPackage ../development/ocaml-modules/ulex { };

    textutils_p4 = callPackage ../development/ocaml-modules/textutils { };

    tls = callPackage ../development/ocaml-modules/tls {
      lwt = ocaml_lwt;
    };

    type_conv_108_08_00 = callPackage ../development/ocaml-modules/type_conv/108.08.00.nix { };
    type_conv_109_60_01 = callPackage ../development/ocaml-modules/type_conv/109.60.01.nix { };
    type_conv_112_01_01 = callPackage ../development/ocaml-modules/type_conv/112.01.01.nix { };
    type_conv =
      if lib.versionOlder "4.02" ocaml.version
      then type_conv_112_01_01
      else if lib.versionOlder "4.00" ocaml.version
      then type_conv_109_60_01
      else if lib.versionOlder "3.12" ocaml.version
      then type_conv_108_08_00
      else null;

    sexplib_108_08_00 = callPackage ../development/ocaml-modules/sexplib/108.08.00.nix { };
    sexplib_111_25_00 = callPackage ../development/ocaml-modules/sexplib/111.25.00.nix { };
    sexplib_112_24_01 = callPackage ../development/ocaml-modules/sexplib/112.24.01.nix { };

    sexplib_p4 =
      if lib.versionOlder "4.02" ocaml.version
      then sexplib_112_24_01
      else if lib.versionOlder "4.00" ocaml.version
      then sexplib_111_25_00
      else if lib.versionOlder "3.12" ocaml.version
      then sexplib_108_08_00
      else null;

    ocaml-protoc = callPackage ../development/ocaml-modules/ocaml-protoc { };

    ocaml_extlib = callPackage ../development/ocaml-modules/extlib { };

    ocb-stubblr = callPackage ../development/ocaml-modules/ocb-stubblr { };

    ocurl = callPackage ../development/ocaml-modules/ocurl { };

    pa_ounit = callPackage ../development/ocaml-modules/pa_ounit { };

    pa_bench = callPackage ../development/ocaml-modules/pa_bench { };

    pa_test = callPackage ../development/ocaml-modules/pa_test { };

    parany = callPackage ../development/ocaml-modules/parany { };

    pipebang = callPackage ../development/ocaml-modules/pipebang { };

    pprint = callPackage ../development/ocaml-modules/pprint { };

    ppx_blob =
      if lib.versionAtLeast ocaml.version "4.02"
      then callPackage ../development/ocaml-modules/ppx_blob {}
      else null;

    ppx_cstruct = callPackage ../development/ocaml-modules/cstruct/ppx.nix {};

    ppx_derivers = callPackage ../development/ocaml-modules/ppx_derivers {};

    ppx_deriving =
      if lib.versionAtLeast ocaml.version "4.02"
      then callPackage ../development/ocaml-modules/ppx_deriving {}
      else null;

    ppx_deriving_protobuf = callPackage ../development/ocaml-modules/ppx_deriving_protobuf {};

    ppx_deriving_rpc = callPackage ../development/ocaml-modules/ppx_deriving_rpc {};

    ppx_deriving_yojson = callPackage ../development/ocaml-modules/ppx_deriving_yojson {};

    ppx_gen_rec = callPackage ../development/ocaml-modules/ppx_gen_rec {};

    ppx_import = callPackage ../development/ocaml-modules/ppx_import {};

    ppx_sqlexpr = callPackage ../development/ocaml-modules/sqlexpr/ppx.nix {};

    ppx_tools =
      if lib.versionAtLeast ocaml.version "4.02"
      then callPackage ../development/ocaml-modules/ppx_tools {}
      else null;

    ppx_tools_versioned = callPackage ../development/ocaml-modules/ppx_tools_versioned { };

    printbox = callPackage ../development/ocaml-modules/printbox { };

    process = callPackage ../development/ocaml-modules/process { };

    ptmap = callPackage ../development/ocaml-modules/ptmap { };

    pycaml = callPackage ../development/ocaml-modules/pycaml { };

    qcheck = callPackage ../development/ocaml-modules/qcheck { };

    qtest = callPackage ../development/ocaml-modules/qtest { };

    re = callPackage ../development/ocaml-modules/re { };

    react = callPackage ../development/ocaml-modules/react { };

    reactivedata = callPackage ../development/ocaml-modules/reactivedata {};

    reason = callPackage ../development/compilers/reason { };

    rope = callPackage ../development/ocaml-modules/rope { };

    rpclib = callPackage ../development/ocaml-modules/rpclib { };

    rresult = callPackage ../development/ocaml-modules/rresult { };

    safepass = callPackage ../development/ocaml-modules/safepass { };

    sedlex = callPackage ../development/ocaml-modules/sedlex { };

    sodium = callPackage ../development/ocaml-modules/sodium { };

    spelll = callPackage ../development/ocaml-modules/spelll { };

    sqlite3EZ = callPackage ../development/ocaml-modules/sqlite3EZ { };

    ssl = callPackage ../development/ocaml-modules/ssl { };

    stdlib-shims = callPackage ../development/ocaml-modules/stdlib-shims { };

    stog = callPackage ../applications/misc/stog { };

    stringext = callPackage ../development/ocaml-modules/stringext { };

    tcslib = callPackage ../development/ocaml-modules/tcslib { };

    toml = callPackage ../development/ocaml-modules/toml { };

    topkg = callPackage ../development/ocaml-modules/topkg { };

    tsdl = callPackage ../development/ocaml-modules/tsdl { };

    twt = callPackage ../development/ocaml-modules/twt { };

    typerep_p4 = callPackage ../development/ocaml-modules/typerep { };

    uchar = callPackage ../development/ocaml-modules/uchar { };

    utop = callPackage ../development/tools/ocaml/utop { };

    uuidm = callPackage ../development/ocaml-modules/uuidm { };

    sawja = callPackage ../development/ocaml-modules/sawja { };

    stdint = callPackage ../development/ocaml-modules/stdint { };

    uucd = callPackage ../development/ocaml-modules/uucd { };
    uucp = callPackage ../development/ocaml-modules/uucp { };
    uunf = callPackage ../development/ocaml-modules/uunf { };

    uri =
      if lib.versionAtLeast ocaml.version "4.3"
      then callPackage ../development/ocaml-modules/uri { }
      else callPackage ../development/ocaml-modules/uri/legacy.nix { };

    uri-sexp = callPackage ../development/ocaml-modules/uri/sexp.nix { };

    uri_p4 = callPackage ../development/ocaml-modules/uri/legacy.nix {
      legacyVersion = true;
    };

    uuseg = callPackage ../development/ocaml-modules/uuseg { };
    uutf = callPackage ../development/ocaml-modules/uutf { };

    variantslib_p4 = callPackage ../development/ocaml-modules/variantslib { };

    vg = callPackage ../development/ocaml-modules/vg { };

    visitors = callPackage ../development/ocaml-modules/visitors { };

    wasm = callPackage ../development/ocaml-modules/wasm { };

    webmachine = callPackage ../development/ocaml-modules/webmachine { };

    wtf8 = callPackage ../development/ocaml-modules/wtf8 { };

    x509 = callPackage ../development/ocaml-modules/x509 { };

    xmlm = callPackage ../development/ocaml-modules/xmlm { };

    xml-light = callPackage ../development/ocaml-modules/xml-light { };

    xtmpl = callPackage ../development/ocaml-modules/xtmpl { };

    yaml = callPackage ../development/ocaml-modules/yaml { };

    yojson = callPackage ../development/ocaml-modules/yojson { };

    zarith = callPackage ../development/ocaml-modules/zarith { };

    zed = callPackage ../development/ocaml-modules/zed { };

    zmq = callPackage ../development/ocaml-modules/zmq { };

    zmq-lwt = callPackage ../development/ocaml-modules/zmq/lwt.nix { };

    ocsigen_deriving = callPackage ../development/ocaml-modules/ocsigen-deriving {
      oasis = ocaml_oasis;
    };

    # Jane Street

    janePackage =
      if lib.versionOlder "4.07" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/janePackage_0_12.nix {}
      else callPackage ../development/ocaml-modules/janestreet/janePackage.nix {};

    janeStreet =
    if lib.versionOlder "4.07" ocaml.version
    then import ../development/ocaml-modules/janestreet/0.12.nix {
      inherit ctypes janePackage num octavius ppxlib re;
      inherit (pkgs) openssl;
    }
    else import ../development/ocaml-modules/janestreet {
      inherit janePackage ocamlbuild angstrom ctypes cryptokit;
      inherit magic-mime num ocaml-migrate-parsetree octavius ounit;
      inherit ppx_deriving re ppxlib;
      inherit (pkgs) openssl;
    };

    janeStreet_0_9_0 = import ../development/ocaml-modules/janestreet/old.nix {
      janePackage = callPackage ../development/ocaml-modules/janestreet/janePackage.nix { defaultVersion = "0.9.0"; };
      inherit lib ocaml ocamlbuild ctypes cryptokit;
      inherit magic-mime num ocaml-migrate-parsetree octavius ounit;
      inherit ppx_deriving re zarith;
      inherit (pkgs) stdenv openssl;
    };

    js_build_tools = callPackage ../development/ocaml-modules/janestreet/js-build-tools.nix {};

    buildOcamlJane = callPackage ../development/ocaml-modules/janestreet/buildOcamlJane.nix {};

    ppx_core =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_core
      else callPackage ../development/ocaml-modules/janestreet/ppx-core.nix {};

    ppx_optcomp =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_optcomp
      else callPackage ../development/ocaml-modules/janestreet/ppx-optcomp.nix {};

    ppx_driver =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_driver
      else callPackage ../development/ocaml-modules/janestreet/ppx-driver.nix {};

    ppx_type_conv =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_type_conv
      else callPackage ../development/ocaml-modules/janestreet/ppx-type-conv.nix {};

    ppx_compare =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_compare
      else callPackage ../development/ocaml-modules/janestreet/ppx-compare.nix {};

    ppx_here =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_here
      else callPackage ../development/ocaml-modules/janestreet/ppx-here.nix {};

    ppx_sexp_conv =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_sexp_conv
      else callPackage ../development/ocaml-modules/janestreet/ppx-sexp-conv.nix {};

    ppx_assert =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_assert
      else callPackage ../development/ocaml-modules/janestreet/ppx-assert.nix {};

    ppx_inline_test =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_inline_test
      else callPackage ../development/ocaml-modules/janestreet/ppx-inline-test.nix {};

    ppx_bench =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_bench
      else callPackage ../development/ocaml-modules/janestreet/ppx-bench.nix {};

    ppx_bin_prot =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_bin_prot
      else callPackage ../development/ocaml-modules/janestreet/ppx-bin-prot.nix {};

    ppx_custom_printf =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_custom_printf
      else callPackage ../development/ocaml-modules/janestreet/ppx-custom-printf.nix {};

    ppx_enumerate =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_enumerate
      else callPackage ../development/ocaml-modules/janestreet/ppx-enumerate.nix {};

    ppx_fail =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_fail
      else callPackage ../development/ocaml-modules/janestreet/ppx-fail.nix {};

    ppx_fields_conv =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_fields_conv
      else callPackage ../development/ocaml-modules/janestreet/ppx-fields-conv.nix {};

    ppx_let =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_let
      else callPackage ../development/ocaml-modules/janestreet/ppx-let.nix {};

    ppx_pipebang =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_pipebang
      else callPackage ../development/ocaml-modules/janestreet/ppx-pipebang.nix {};

    ppx_sexp_message =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_sexp_message
      else callPackage ../development/ocaml-modules/janestreet/ppx-sexp-message.nix {};

    ppx_sexp_value =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_sexp_value
      else callPackage ../development/ocaml-modules/janestreet/ppx-sexp-value.nix {};

    ppx_typerep_conv =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_typerep_conv
      else callPackage ../development/ocaml-modules/janestreet/ppx-typerep-conv.nix {};

    ppx_variants_conv =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_variants_conv
      else callPackage ../development/ocaml-modules/janestreet/ppx-variants-conv.nix {};

    ppx_expect =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_expect
      else callPackage ../development/ocaml-modules/janestreet/ppx-expect.nix {};

    ppx_jane =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.ppx_jane
      else callPackage ../development/ocaml-modules/janestreet/ppx-jane.nix {};


    # Core sublibs
    typerep =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.typerep
      else if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/typerep.nix {}
      else typerep_p4;

    fieldslib =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.fieldslib
      else if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/fieldslib.nix {}
      else fieldslib_p4;

    sexplib =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.sexplib
      else if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/sexplib.nix {}
      else sexplib_p4;

    variantslib =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.variantslib
      else if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/variantslib.nix {}
      else variantslib_p4;

    bin_prot =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.bin_prot
      else if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/bin_prot.nix {}
      else bin_prot_p4;

    core_bench =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.core_bench else
      callPackage ../development/ocaml-modules/janestreet/core_bench.nix {};

    core_kernel =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.core_kernel
      else if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/core_kernel.nix {}
      else core_kernel_p4;

    core =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.core
      else if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/core.nix {}
      else core_p4;

    re2 =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.re2
      else if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/re2.nix {}
      else re2_p4;

    textutils =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.textutils
      else if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/textutils.nix {}
      else textutils_p4;

    core_extended =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.core_extended
      else if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/core-extended.nix {}
      else core_extended_p4;

    async_kernel =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.async_kernel
      else if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/async-kernel.nix {}
      else async_kernel_p4;

    async_rpc_kernel =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.async_rpc_kernel
      else callPackage ../development/ocaml-modules/janestreet/async-rpc-kernel.nix {};

    async_unix =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.async_unix
      else if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/async-unix.nix {}
      else async_unix_p4;

    async_extra =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.async_extra
      else if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/async-extra.nix {}
      else async_extra_p4;

    async =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.async
      else if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/async.nix {}
      else async_p4;

    async_ssl =
      if lib.versionOlder "4.03" ocaml.version
      then janeStreet.async_ssl
      else callPackage ../development/ocaml-modules/janestreet/async_ssl.nix { };

    # Apps / from all-packages

    ocamlnat = callPackage  ../development/ocaml-modules/ocamlnat { };

    trv = callPackage ../development/tools/misc/trv { };

    omake_rc1 = callPackage ../development/tools/ocaml/omake/0.9.8.6-rc1.nix { };

    google-drive-ocamlfuse = callPackage ../applications/networking/google-drive-ocamlfuse { };

    unison = callPackage ../applications/networking/sync/unison {
      enableX11 = config.unison.enableX11 or true;
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

  ocamlPackages_latest = ocamlPackages_4_09;

  ocamlPackages = ocamlPackages_4_07;
}
