{ stdenv, lib, akku, curl, git }:
let
  joinOverrides =
    overrides: pkg: old:
    lib.attrsets.mergeAttrsList (map (o: o pkg old) overrides);
  addToBuildInputs =
    extras: pkg: old:
    { propagatedBuildInputs = old.propagatedBuildInputs ++ extras; };
  broken = lib.addMetaAttrs { broken = true; };
  skipTests = pkg: old: { doCheck = false; };
  # debugging
  showLibs = pkg: old: { preCheck = "echo $CHEZSCHEMELIBDIRS"; };
  runTests = pkg: old: { doCheck = true; };
  brokenOnAarch64 = _: lib.addMetaAttrs { broken = stdenv.hostPlatform.isAarch64; };
  brokenOnx86_64Darwin = lib.addMetaAttrs { broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64; };
in
{
  chez-srfi = joinOverrides [
    (pkg: old: {
      preCheck = ''
        SKIP='
        multi-dimensional-arrays.sps
        time.sps
        tables-test.ikarus.sps
        lazy.sps
        '
      '';
    })

    # nothing builds on ARM Macs because of this
    brokenOnAarch64
  ];

  akku-r7rs = pkg: old: {
    preBuild = ''
      # tests aren't exported modules
      rm -rf tests
    '';
  };

  akku = joinOverrides [
    # uses chez
    (addToBuildInputs [ curl git ])
    (pkg: old: {
      # bump akku to 1.1.0-unstable-2024-03-03
      src = akku.src;
    })
    # not a tar archive
    (pkg: old: removeAttrs old [ "unpackPhase" ])
  ];

  machine-code = pkg: old: {
    # fails on hydra with 'Log limit exceeded'
    postPatch = ''
      rm tests/all-a64.sps
    '';
  };

  # circular dependency on wak-trc-testing !?
  wak-foof-loop = skipTests;

  scheme-langserver = joinOverrides [
    (pkg: old: {
      preInstall = ''
        # add the lsp executable to be installed
        echo "#!/usr/bin/env scheme-script" > .akku/bin/scheme-langserver
        cat run.ss >> .akku/bin/scheme-langserver
        chmod +x .akku/bin/scheme-langserver
      '';
    })
    skipTests
  ];

  # broken tests
  xitomatl = skipTests;
  ufo-threaded-function = skipTests;

  # unsupported schemes, it seems.
  loko-srfi = broken;
  ac-d-bus = broken;

  # todo:
  # system-specific:

  # scheme-langserver doesn't work because of this
  ufo-thread-pool = brokenOnx86_64Darwin;

  # broken everywhere:
  chibi-math-linalg = broken;
  chibi-mecab = broken;
  chibi-ssl = broken;
  chibi-voting = broken;
  chibi-xgboost = broken;
  dockerfile = broken;
  in-progress-hash-bimaps = broken;
  in-progress-hash-tables = broken;
  rapid-analyze-library = broken;
  rapid-args-fold = broken;
  rapid-eliminate-mutable-variables = broken;
  rapid-fix-letrec = broken;
  rapid-graph = broken;
  rapid-library-definition = broken;
  rapid-mapping = broken;
  rapid-read = broken;
  rapid-set = broken;
  rapid-syntax = broken;
  read-char-if = broken;
  shell-quote = broken;
  srfi-19 = broken;
  srfi-64 = broken;
  srfi-179 = broken;
  string-inflection = broken;
  tex-parser = broken;
  trivial-tar-writer = broken;
  unpack-assoc = broken;
  agave = broken;
  box2d-lite = broken;
  chez-soop = broken;
  chez-stats = broken;
  dataframe = broken;
  dharmalab = broken;
  dorodango = broken;
  fectors = broken;
  fs-fatfs = broken;
  fs-partitions = broken;
  gnuplot-pipe = broken;
  http-pixiu = broken;
  influx-client = broken;
  linenoise = broken;
  mpl = broken;
  mummel = broken;
  ocelotl = broken;
  r6lint = broken;
  r6rs-clos = broken;
  r6rs-coap = broken;
  r6rs-msgpack = broken;
  scheme-bytestructures = broken;
  surfage = broken;
  swish = broken;
  text-mode = broken;
  thunderchez = broken;
  wak-ssax = broken;
  wak-sxml-tools = broken;
  yxskaft = broken;
}
