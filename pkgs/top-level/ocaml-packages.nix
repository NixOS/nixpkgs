{ lib, callPackage, newScope, pkgs, config, system }:

let
  mkOcamlPackages = ocaml: overrides:
    let
      packageSet = self:
        with self; let inherit (self) callPackage; in
  {
    callPackage = newScope self;

    inherit ocaml;

    # Libs

    buildOcaml = callPackage ../build-support/ocaml { };

    acgtk = callPackage ../applications/science/logic/acgtk { };

    alcotest = callPackage ../development/ocaml-modules/alcotest {};

    angstrom = callPackage ../development/ocaml-modules/angstrom { };

    ansiterminal = callPackage ../development/ocaml-modules/ansiterminal { };

    apron = callPackage ../development/ocaml-modules/apron { };

    asn1-combinators = callPackage ../development/ocaml-modules/asn1-combinators { };

    astring = callPackage ../development/ocaml-modules/astring { };

    async_extra_p4 = callPackage ../development/ocaml-modules/async_extra { };

    async_find = callPackage ../development/ocaml-modules/async_find { };

    async_kernel_p4 = callPackage ../development/ocaml-modules/async_kernel { };

    async_shell = callPackage ../development/ocaml-modules/async_shell { };

    async_ssl = callPackage ../development/ocaml-modules/async_ssl { };

    async_unix_p4 = callPackage ../development/ocaml-modules/async_unix { };

    async_p4 =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/async { }
      else null;

    atd = callPackage ../development/ocaml-modules/atd { };

    atdgen = callPackage ../development/ocaml-modules/atdgen { };

    base64 = callPackage ../development/ocaml-modules/base64 { };

    bolt = callPackage ../development/ocaml-modules/bolt { };

    bitstring =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/bitstring { }
      else callPackage ../development/ocaml-modules/bitstring/2.0.4.nix { };

    camlidl = callPackage ../development/tools/ocaml/camlidl { };

    camlp4 =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/tools/ocaml/camlp4 { }
      else null;

    camlp5_old_strict =
      if lib.versionOlder "4.00" ocaml.version
      then camlp5_6_strict
      else callPackage ../development/tools/ocaml/camlp5/5.15.nix { };

    camlp5_old_transitional =
      if lib.versionOlder "4.00" ocaml.version
      then camlp5_6_transitional
      else callPackage ../development/tools/ocaml/camlp5/5.15.nix {
        transitional = true;
      };

    camlp5_6_strict = callPackage ../development/tools/ocaml/camlp5 { };

    camlp5_6_transitional = callPackage ../development/tools/ocaml/camlp5 {
      transitional = true;
    };

    camlp5_strict = camlp5_6_strict;

    camlp5_transitional = camlp5_6_transitional;

    camlpdf = callPackage ../development/ocaml-modules/camlpdf { };

    calendar = callPackage ../development/ocaml-modules/calendar { };

    camlzip = callPackage ../development/ocaml-modules/camlzip { };

    camomile_0_8_2 = callPackage ../development/ocaml-modules/camomile/0.8.2.nix { };
    camomile = callPackage ../development/ocaml-modules/camomile { };

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
    camlimages = camlimages_4_1;

    conduit = callPackage ../development/ocaml-modules/conduit {
       lwt = ocaml_lwt;
    };

    biniou = callPackage ../development/ocaml-modules/biniou { };

    bin_prot_p4 = callPackage ../development/ocaml-modules/bin_prot { };

    ocaml_cairo = callPackage ../development/ocaml-modules/ocaml-cairo { };

    ocaml_cairo2 = callPackage ../development/ocaml-modules/ocaml-cairo2 { };

    cil = callPackage ../development/ocaml-modules/cil { };

    cmdliner = callPackage ../development/ocaml-modules/cmdliner { };

    cohttp = callPackage ../development/ocaml-modules/cohttp {
      lwt = ocaml_lwt;
    };

    config-file = callPackage ../development/ocaml-modules/config-file { };

    containers = callPackage ../development/ocaml-modules/containers { };

    cow = callPackage ../development/ocaml-modules/cow { };

    cpdf = callPackage ../development/ocaml-modules/cpdf { };

    cppo = callPackage ../development/tools/ocaml/cppo { };

    cryptokit = callPackage ../development/ocaml-modules/cryptokit { };

    cstruct = callPackage ../development/ocaml-modules/cstruct {
      lwt = ocaml_lwt;
    };

    csv = callPackage ../development/ocaml-modules/csv { };

    curses = callPackage ../development/ocaml-modules/curses { };

    custom_printf = callPackage ../development/ocaml-modules/custom_printf { };

    ctypes = callPackage ../development/ocaml-modules/ctypes { };

    dolmen =  callPackage ../development/ocaml-modules/dolmen { };

    dolog = callPackage ../development/ocaml-modules/dolog { };

    easy-format = callPackage ../development/ocaml-modules/easy-format { };

    eff = callPackage ../development/interpreters/eff { };

    eliom = callPackage ../development/ocaml-modules/eliom { };

    enumerate = callPackage ../development/ocaml-modules/enumerate { };

    erm_xml = callPackage ../development/ocaml-modules/erm_xml { };

    erm_xmpp = callPackage ../development/ocaml-modules/erm_xmpp { };

    erm_xmpp_0_3 = callPackage ../development/ocaml-modules/erm_xmpp/0.3.nix { };

    estring = callPackage ../development/ocaml-modules/estring { };

    ezjsonm = callPackage ../development/ocaml-modules/ezjsonm {
      lwt = ocaml_lwt;
    };

    faillib = callPackage ../development/ocaml-modules/faillib { };

    fieldslib_p4 = callPackage ../development/ocaml-modules/fieldslib { };

    fileutils = callPackage ../development/ocaml-modules/fileutils { };

    findlib = callPackage ../development/tools/ocaml/findlib { };

    fix = callPackage ../development/ocaml-modules/fix { };

    fmt = callPackage ../development/ocaml-modules/fmt { };

    fontconfig = callPackage ../development/ocaml-modules/fontconfig {
      inherit (pkgs) fontconfig;
    };

    fpath = callPackage ../development/ocaml-modules/fpath { };

    functory = callPackage ../development/ocaml-modules/functory { };

    gen = callPackage ../development/ocaml-modules/gen { };

    herelib = callPackage ../development/ocaml-modules/herelib { };

    io-page = callPackage ../development/ocaml-modules/io-page { };

    ipaddr_p4 = callPackage ../development/ocaml-modules/ipaddr/2.6.1.nix { };

    ipaddr =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/ipaddr { }
      else ipaddr_p4;

    iso8601 = callPackage ../development/ocaml-modules/iso8601 { };

    javalib = callPackage ../development/ocaml-modules/javalib {
      extlib = ocaml_extlib_maximal;
    };

    dypgen = callPackage ../development/ocaml-modules/dypgen { };

    gapi_ocaml = callPackage ../development/ocaml-modules/gapi-ocaml { };

    gg = callPackage ../development/ocaml-modules/gg { };

    gmetadom = callPackage ../development/ocaml-modules/gmetadom { };

    gtktop = callPackage ../development/ocaml-modules/gtktop { };

    hex = callPackage ../development/ocaml-modules/hex { };

    jingoo = callPackage ../development/ocaml-modules/jingoo {
      batteries = ocaml_batteries;
      pcre = ocaml_pcre;
    };

    js_of_ocaml = callPackage ../development/tools/ocaml/js_of_ocaml { };

    jsonm = callPackage ../development/ocaml-modules/jsonm { };

    lablgl = callPackage ../development/ocaml-modules/lablgl { };

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

    lambdaTerm-1_6 = callPackage ../development/ocaml-modules/lambda-term/1.6.nix { };
    lambdaTerm =
      if lib.versionOlder "4.01" ocaml.version
      then callPackage ../development/ocaml-modules/lambda-term { }
      else lambdaTerm-1_6;

    llvm = callPackage ../development/ocaml-modules/llvm {
      llvm = pkgs.llvm_37;
    };

    logs = callPackage ../development/ocaml-modules/logs {
      lwt = ocaml_lwt;
    };

    macaque = callPackage ../development/ocaml-modules/macaque { };

    magic-mime = callPackage ../development/ocaml-modules/magic-mime { };

    magick = callPackage ../development/ocaml-modules/magick { };

    markup = callPackage ../development/ocaml-modules/markup { lwt = ocaml_lwt; };

    menhir = callPackage ../development/ocaml-modules/menhir { };

    merlin = callPackage ../development/tools/ocaml/merlin { };

    mezzo = callPackage ../development/compilers/mezzo { };

    mlgmp =  callPackage ../development/ocaml-modules/mlgmp { };

    mlgmpidl =  callPackage ../development/ocaml-modules/mlgmpidl { };

    mparser =  callPackage ../development/ocaml-modules/mparser { };

    mtime =  callPackage ../development/ocaml-modules/mtime { };

    nocrypto =  callPackage ../development/ocaml-modules/nocrypto {
      lwt = ocaml_lwt;
    };

    notty = callPackage ../development/ocaml-modules/notty {
      lwt = ocaml_lwt;
    };

    ocaml_batteries = callPackage ../development/ocaml-modules/batteries { };

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

    ocaml_expat = callPackage ../development/ocaml-modules/expat { };

    frontc = callPackage ../development/ocaml-modules/frontc { };

    ocamlfuse = callPackage ../development/ocaml-modules/ocamlfuse { };

    ocaml_gettext = callPackage ../development/ocaml-modules/ocaml-gettext { };

    ocamlgraph = callPackage ../development/ocaml-modules/ocamlgraph { };

    ocaml_http = callPackage ../development/ocaml-modules/http { };

    ocaml_libvirt = callPackage ../development/ocaml-modules/ocaml-libvirt { };

    ocamlify = callPackage ../development/tools/ocaml/ocamlify { };

    ocaml_lwt = callPackage ../development/ocaml-modules/lwt { };

    ocamlmod = callPackage ../development/tools/ocaml/ocamlmod { };

    ocaml_mysql = callPackage ../development/ocaml-modules/mysql { };

    ocamlnet = callPackage ../development/ocaml-modules/ocamlnet { };

    ocaml_oasis = callPackage ../development/tools/ocaml/oasis { };
    ocaml_oasis_46 = callPackage ../development/tools/ocaml/oasis/0.4.6.nix { };

    ocaml_optcomp = callPackage ../development/ocaml-modules/optcomp { };

    ocaml_pcre = callPackage ../development/ocaml-modules/pcre {};

    pgocaml = callPackage ../development/ocaml-modules/pgocaml {};

    ocaml_react = callPackage ../development/ocaml-modules/react { };
    reactivedata = callPackage ../development/ocaml-modules/reactivedata {};

    ocamlscript = callPackage ../development/tools/ocaml/ocamlscript { };

    ocamlsdl= callPackage ../development/ocaml-modules/ocamlsdl { };

    ocaml_sqlite3 = callPackage ../development/ocaml-modules/sqlite3 { };

    ocaml_ssl = callPackage ../development/ocaml-modules/ssl { };

    ocaml_text = callPackage ../development/ocaml-modules/ocaml-text { };

    ocpBuild = callPackage ../development/tools/ocaml/ocp-build { };

    ocpIndent = callPackage ../development/tools/ocaml/ocp-indent { };

    ocp-index = callPackage ../development/tools/ocaml/ocp-index { };

    ocplib-endian = callPackage ../development/ocaml-modules/ocplib-endian { };

    ocplib-simplex = callPackage ../development/ocaml-modules/ocplib-simplex { };

    ocsigen_server = callPackage ../development/ocaml-modules/ocsigen-server { };

    ojquery = callPackage ../development/ocaml-modules/ojquery { };

    omd = callPackage ../development/ocaml-modules/omd { };

    otfm = callPackage ../development/ocaml-modules/otfm { };

    otr = callPackage ../development/ocaml-modules/otr { };

    owee = callPackage ../development/ocaml-modules/owee { };

    ounit = callPackage ../development/ocaml-modules/ounit { };

    piqi = callPackage ../development/ocaml-modules/piqi { };
    piqi-ocaml = callPackage ../development/ocaml-modules/piqi-ocaml { };

    ptime = callPackage ../development/ocaml-modules/ptime { };

    re2_p4 = callPackage ../development/ocaml-modules/re2 { };

    result = callPackage ../development/ocaml-modules/ocaml-result { };

    sequence = callPackage ../development/ocaml-modules/sequence { };

    spacetime_lib = if lib.versionOlder "4.04" ocaml.version then
    callPackage ../development/tools/ocaml/ocamlbuild { }
    else
    null;

    sqlexpr = callPackage ../development/ocaml-modules/sqlexpr { };

    tuntap = callPackage ../development/ocaml-modules/tuntap { };

    tyxml = callPackage ../development/ocaml-modules/tyxml { };

    ulex = callPackage ../development/ocaml-modules/ulex { };

    ulex08 = callPackage ../development/ocaml-modules/ulex/0.8 {
      camlp5 = camlp5_transitional;
    };

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

    ocaml_extlib = callPackage ../development/ocaml-modules/extlib { };
    ocaml_extlib_maximal = callPackage ../development/ocaml-modules/extlib {
      minimal = false;
    };

    ocb-stubblr = callPackage ../development/ocaml-modules/ocb-stubblr { };

    ocurl = callPackage ../development/ocaml-modules/ocurl { };

    pa_ounit = callPackage ../development/ocaml-modules/pa_ounit { };

    pa_bench = callPackage ../development/ocaml-modules/pa_bench { };

    pa_test = callPackage ../development/ocaml-modules/pa_test { };

    pipebang = callPackage ../development/ocaml-modules/pipebang { };

    pprint = callPackage ../development/ocaml-modules/pprint { };

    ppx_blob =
      if lib.versionAtLeast ocaml.version "4.02"
      then callPackage ../development/ocaml-modules/ppx_blob {}
      else null;

    ppx_deriving =
      if lib.versionAtLeast ocaml.version "4.02"
      then callPackage ../development/ocaml-modules/ppx_deriving {}
      else null;

    ppx_import = callPackage ../development/ocaml-modules/ppx_import {};

    ppx_tools =
      if lib.versionAtLeast ocaml.version "4.02"
      then callPackage ../development/ocaml-modules/ppx_tools {}
      else null;

    pycaml = callPackage ../development/ocaml-modules/pycaml { };

    qcheck = callPackage ../development/ocaml-modules/qcheck {
      oasis = ocaml_oasis;
    };

    qtest = callPackage ../development/ocaml-modules/qtest { };

    re = callPackage ../development/ocaml-modules/re { };

    safepass = callPackage ../development/ocaml-modules/safepass { };

    sedlex = callPackage ../development/ocaml-modules/sedlex { };

    sqlite3EZ = callPackage ../development/ocaml-modules/sqlite3EZ { };

    stringext = callPackage ../development/ocaml-modules/stringext { };

    topkg = callPackage ../development/ocaml-modules/topkg { };

    tsdl = callPackage ../development/ocaml-modules/tsdl { };

    twt = callPackage ../development/ocaml-modules/twt { };

    typerep_p4 = callPackage ../development/ocaml-modules/typerep { };

    uchar = callPackage ../development/ocaml-modules/uchar { };

    utop = callPackage ../development/tools/ocaml/utop { };

    uuidm = callPackage ../development/ocaml-modules/uuidm { };

    sawja = callPackage ../development/ocaml-modules/sawja { };

    uucd = callPackage ../development/ocaml-modules/uucd { };
    uucp = callPackage ../development/ocaml-modules/uucp { };
    uunf = callPackage ../development/ocaml-modules/uunf { };

    uri = callPackage ../development/ocaml-modules/uri { };
    uri_p4 = callPackage ../development/ocaml-modules/uri {
      legacyVersion = true;
    };

    uuseg = callPackage ../development/ocaml-modules/uuseg { };
    uutf = callPackage ../development/ocaml-modules/uutf { };

    variantslib_p4 = callPackage ../development/ocaml-modules/variantslib { };

    vg = callPackage ../development/ocaml-modules/vg { };

    x509 = callPackage ../development/ocaml-modules/x509 { };

    xmlm = callPackage ../development/ocaml-modules/xmlm { };

    xml-light = callPackage ../development/ocaml-modules/xml-light { };

    yojson = callPackage ../development/ocaml-modules/yojson { };

    zarith = callPackage ../development/ocaml-modules/zarith { };

    zed = callPackage ../development/ocaml-modules/zed { };

    ocsigen_deriving = callPackage ../development/ocaml-modules/ocsigen-deriving {
      oasis = ocaml_oasis;
    };

    # Jane Street
    js_build_tools = callPackage ../development/ocaml-modules/janestreet/js-build-tools.nix {};

    buildOcamlJane = callPackage ../development/ocaml-modules/janestreet/buildOcamlJane.nix {};

    ppx_core = callPackage ../development/ocaml-modules/janestreet/ppx-core.nix {};

    ppx_optcomp = callPackage ../development/ocaml-modules/janestreet/ppx-optcomp.nix {};

    ppx_driver = callPackage ../development/ocaml-modules/janestreet/ppx-driver.nix {};

    ppx_type_conv = callPackage ../development/ocaml-modules/janestreet/ppx-type-conv.nix {};

    ppx_compare = callPackage ../development/ocaml-modules/janestreet/ppx-compare.nix {};

    ppx_here = callPackage ../development/ocaml-modules/janestreet/ppx-here.nix {};

    ppx_sexp_conv = callPackage ../development/ocaml-modules/janestreet/ppx-sexp-conv.nix {};

    ppx_assert = callPackage ../development/ocaml-modules/janestreet/ppx-assert.nix {};

    ppx_inline_test = callPackage ../development/ocaml-modules/janestreet/ppx-inline-test.nix {};

    ppx_bench = callPackage ../development/ocaml-modules/janestreet/ppx-bench.nix {};

    ppx_bin_prot = callPackage ../development/ocaml-modules/janestreet/ppx-bin-prot.nix {};

    ppx_custom_printf = callPackage ../development/ocaml-modules/janestreet/ppx-custom-printf.nix {};

    ppx_enumerate = callPackage ../development/ocaml-modules/janestreet/ppx-enumerate.nix {};

    ppx_fail = callPackage ../development/ocaml-modules/janestreet/ppx-fail.nix {};

    ppx_fields_conv = callPackage ../development/ocaml-modules/janestreet/ppx-fields-conv.nix {};

    ppx_let = callPackage ../development/ocaml-modules/janestreet/ppx-let.nix {};

    ppx_pipebang = callPackage ../development/ocaml-modules/janestreet/ppx-pipebang.nix {};

    ppx_sexp_message = callPackage ../development/ocaml-modules/janestreet/ppx-sexp-message.nix {};

    ppx_sexp_value = callPackage ../development/ocaml-modules/janestreet/ppx-sexp-value.nix {};

    ppx_typerep_conv = callPackage ../development/ocaml-modules/janestreet/ppx-typerep-conv.nix {};

    ppx_variants_conv = callPackage ../development/ocaml-modules/janestreet/ppx-variants-conv.nix {};

    ppx_expect = callPackage ../development/ocaml-modules/janestreet/ppx-expect.nix {};

    ppx_jane = callPackage ../development/ocaml-modules/janestreet/ppx-jane.nix {};


    # Core sublibs
    typerep =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/typerep.nix {}
      else typerep_p4;

    fieldslib =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/fieldslib.nix {}
      else fieldslib_p4;

    sexplib =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/sexplib.nix {}
      else sexplib_p4;

    variantslib =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/variantslib.nix {}
      else variantslib_p4;

    bin_prot =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/bin_prot.nix {}
      else bin_prot_p4;

    core_kernel =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/core_kernel.nix {}
      else core_kernel_p4;

    core =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/core.nix {}
      else core_p4;

    re2 =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/re2.nix {}
      else re2_p4;

    textutils =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/textutils.nix {}
      else textutils_p4;

    core_extended =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/core-extended.nix {}
      else core_extended_p4;

    async_kernel =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/async-kernel.nix {}
      else async_kernel_p4;

    async_rpc_kernel = callPackage ../development/ocaml-modules/janestreet/async-rpc-kernel.nix {};

    async_unix =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/async-unix.nix {}
      else async_unix_p4;

    async_extra =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/async-extra.nix {}
      else async_extra_p4;

    async =
      if lib.versionOlder "4.02" ocaml.version
      then callPackage ../development/ocaml-modules/janestreet/async.nix {}
      else async_p4;

    # Apps / from all-packages

    wyrd = callPackage ../tools/misc/wyrd { };

    haxe = callPackage ../development/compilers/haxe { };

    ocaml-top = callPackage ../development/tools/ocaml/ocaml-top { };

    ocamlnat = callPackage  ../development/ocaml-modules/ocamlnat { };

    trv = callPackage ../development/tools/misc/trv { };

    omake_rc1 = callPackage ../development/tools/ocaml/omake/0.9.8.6-rc1.nix { };

    verasco = callPackage ../development/tools/analysis/verasco (
      if system == "x86_64-linux"
      then { tools = pkgs.pkgsi686Linux.stdenv.cc; }
      else {}
    );

    glsurf = callPackage ../applications/science/math/glsurf {
      libpng = pkgs.libpng12;
      giflib = pkgs.giflib_4_1;
      camlimages = camlimages_4_0;
    };

    google-drive-ocamlfuse = callPackage ../applications/networking/google-drive-ocamlfuse { };


    monotoneViz = callPackage ../applications/version-management/monotone-viz {
      inherit (pkgs.gnome2) libgnomecanvas glib;
    };

    unison = callPackage ../applications/networking/sync/unison {
      enableX11 = config.unison.enableX11 or true;
    };

    hol_light = callPackage ../applications/science/logic/hol_light {
      camlp5 = camlp5_strict;
    };

    matita = callPackage ../applications/science/logic/matita {
      ulex08 = ulex08.override { camlp5 = camlp5_old_transitional; };
    };

    matita_130312 = callPackage ../applications/science/logic/matita/130312.nix { };

    ott = callPackage ../applications/science/logic/ott {
      camlp5 = camlp5_transitional;
    };

  };
    in lib.fix' (lib.extends overrides packageSet);
in rec
{

  inherit mkOcamlPackages;

  ocamlPackages_3_08_0 = mkOcamlPackages (callPackage ../development/compilers/ocaml/3.08.0.nix { }) (self: super: { lablgtk = self.lablgtk_2_14; });

  ocamlPackages_3_10_0 = mkOcamlPackages (callPackage ../development/compilers/ocaml/3.10.0.nix { }) (self: super: { lablgtk = self.lablgtk_2_14; });

  ocamlPackages_3_11_2 = mkOcamlPackages (callPackage ../development/compilers/ocaml/3.11.2.nix { }) (self: super: { lablgtk = self.lablgtk_2_14; });

  ocamlPackages_3_12_1 = mkOcamlPackages (callPackage ../development/compilers/ocaml/3.12.1.nix { }) (self: super: { camlimages = self.camlimages_4_0; });

  ocamlPackages_4_00_1 = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.00.1.nix { }) (self: super: { });

  ocamlPackages_4_01_0 = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.01.0.nix { }) (self: super: { });

  ocamlPackages_4_02 = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.02.nix { }) (self: super: { });

  ocamlPackages_4_03 = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.03.nix { }) (self: super: { });

  ocamlPackages_4_04 = mkOcamlPackages (callPackage ../development/compilers/ocaml/4.04.nix { }) (self: super: { });

  ocamlPackages_latest = ocamlPackages_4_04;

  ocamlPackages = ocamlPackages_4_02;
}
