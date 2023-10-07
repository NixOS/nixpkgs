{ lib, stdenv, fetchFromGitHub, postgresql }:

let
  source = {
    "16" = {
      version = "1.6.0";
      hash = "sha256-lg7N0QblluTgtNo1tGZjirNJSyQXtcAEs9Jqd3zx0Sg=";
    };
    "15" = {
      version = "1.5.1";
      hash = "sha256-o8Hepf/Mc1ClRTLZ6PBdqU4jSdlz+ijVgl2vJKmIc6M=";
    };
    "14" = {
      version = "1.4.2";
      hash = "sha256-nGyKcNY57RdQdZKSaBPk2/YbT0Annz1ZevH0lKswdhA=";
    };
    "13" = {
      version = "1.3.9";
      hash = "sha256-KGcHDwk8CgNHPZARfLBfS8r7TRCP9LPjT+m4fNSnnW0=";
    };
    "12" = {
      version = "1.3.9";
      hash = "sha256-64/dlm6e4flCxMQ8efsxfKSlja+Tko0zsghTgLatN+Y=";
    };
    "11" = {
      version = "1.3.9";
      hash = "sha256-8t/HhB/2Kjx4xMItmmKv3g9gba5VCBHdplYtYD/3UhA=";
    };
  }.${lib.versions.major postgresql.version} or (throw "Source for pg_hint_plan is not available for ${postgresql.version}");
in
stdenv.mkDerivation {
  pname = "pg_hint_plan";
  inherit (source) version;

  src = fetchFromGitHub {
    owner = "ossc-db";
    repo = "pg_hint_plan";
    rev = "REL${lib.versions.major postgresql.version}_${builtins.replaceStrings ["."] ["_"] source.version}";
    inherit (source) hash;
  };

  postPatch = lib.optionalString (lib.versionOlder postgresql.version "14") ''
    # https://github.com/ossc-db/pg_hint_plan/commit/e9e564ad59b8bd4a03e0f13b95b5122712e573e6
    substituteInPlace Makefile --replace "LDFLAGS+=-Wl,--build-id" ""
  '';

  buildInputs = [ postgresql ];

  installPhase = ''
    install -D -t $out/lib pg_hint_plan.so
    install -D -t $out/share/postgresql/extension *.sql
    install -D -t $out/share/postgresql/extension *.control
  '';

  meta = with lib; {
    description = "Extension to tweak PostgreSQL execution plans using so-called 'hints' in SQL comments";
    homepage = "https://github.com/ossc-db/pg_hint_plan";
    maintainers = with maintainers; [ _1000101 ];
    platforms = postgresql.meta.platforms;
    license = licenses.bsd3;
  };
}
