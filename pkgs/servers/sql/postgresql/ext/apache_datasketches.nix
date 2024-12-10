{
  stdenv,
  lib,
  fetchFromGitHub,
  postgresql,
  boost182,
  nixosTests,
}:

let
  version = "1.7.0";

  main_src = fetchFromGitHub {
    name = "datasketches-postgresql";
    owner = "apache";
    repo = "datasketches-postgresql";
    rev = "refs/tags/${version}";
    hash = "sha256-W41uAs3W4V7c9O/wBw3rut65bcmY8EdQS1/tPszMGqA=";
  };

  cpp_src = fetchFromGitHub {
    name = "datasketches-cpp";
    owner = "apache";
    repo = "datasketches-cpp";
    rev = "refs/tags/5.0.2";
    hash = "sha256-yGk1OckYipAgLTQK6w6p6EdHMxBIQSjPV/MMND3cDks=";
  };
in

stdenv.mkDerivation {
  pname = "apache_datasketches";
  inherit version;

  srcs = [
    main_src
    cpp_src
  ];

  sourceRoot = main_src.name;

  buildInputs = [
    postgresql
    boost182
  ];

  patchPhase = ''
    runHook prePatch
    cp -r ../${cpp_src.name} .
    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall
    install -D -m 644 ./datasketches${postgresql.dlSuffix} -t $out/lib/
    cat \
      sql/datasketches_cpc_sketch.sql \
      sql/datasketches_kll_float_sketch.sql \
      sql/datasketches_kll_double_sketch.sql \
      sql/datasketches_theta_sketch.sql \
      sql/datasketches_frequent_strings_sketch.sql \
      sql/datasketches_hll_sketch.sql \
      sql/datasketches_aod_sketch.sql \
      sql/datasketches_req_float_sketch.sql \
      sql/datasketches_quantiles_double_sketch.sql \
      > sql/datasketches--${version}.sql
    install -D -m 644 ./datasketches.control -t $out/share/postgresql/extension
    install -D -m 644 \
      ./sql/datasketches--${version}.sql \
      ./sql/datasketches--1.3.0--1.4.0.sql \
      ./sql/datasketches--1.4.0--1.5.0.sql \
      ./sql/datasketches--1.5.0--1.6.0.sql \
      ./sql/datasketches--1.6.0--1.7.0.sql \
      -t $out/share/postgresql/extension
    runHook postInstall
  '';

  passthru.tests.apache_datasketches = nixosTests.apache_datasketches;

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
}
