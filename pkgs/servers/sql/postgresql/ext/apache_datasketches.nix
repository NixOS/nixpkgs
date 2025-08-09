{
  boost186,
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
}:

let
  version = "1.7.0";

  main_src = fetchFromGitHub {
    name = "datasketches-postgresql";
    owner = "apache";
    repo = "datasketches-postgresql";
    tag = version;
    hash = "sha256-W41uAs3W4V7c9O/wBw3rut65bcmY8EdQS1/tPszMGqA=";
  };

  cpp_src = fetchFromGitHub {
    name = "datasketches-cpp";
    owner = "apache";
    repo = "datasketches-cpp";
    tag = "5.0.2";
    hash = "sha256-yGk1OckYipAgLTQK6w6p6EdHMxBIQSjPV/MMND3cDks=";
  };
in

postgresqlBuildExtension (finalAttrs: {
  pname = "apache_datasketches";
  inherit version;

  srcs = [
    main_src
    cpp_src
  ];

  sourceRoot = main_src.name;

  # fails to build with boost 1.87
  buildInputs = [ boost186 ];

  patchPhase = ''
    runHook prePatch
    cp -r ../${cpp_src.name} .
    runHook postPatch
  '';

  enableUpdateScript = false;
  passthru.tests.extension = postgresqlTestExtension {
    inherit (finalAttrs) finalPackage;
    sql = ''
      CREATE EXTENSION datasketches;
      SELECT hll_sketch_to_string(hll_sketch_build(1));
    '';
  };

  meta = {
    description = "PostgreSQL extension providing approximate algorithms for distinct item counts, quantile estimation and frequent items detection";
    longDescription = ''
      apache_datasketches is an extension to support approximate algorithms on PostgreSQL. The implementation
      is based on the Apache Datasketches CPP library, and provides support for HyperLogLog,
      Compressed Probabilistic Counting, KLL, Frequent strings, and Theta sketches.
    '';
    homepage = "https://datasketches.apache.org/";
    platforms = postgresql.meta.platforms;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mmusnjak ];
  };
})
