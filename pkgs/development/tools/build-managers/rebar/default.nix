{ lib, stdenv, fetchurl, erlang }:


let
  version = "2.6.4";
in
stdenv.mkDerivation {
  pname = "rebar";
  inherit version;

  src = fetchurl {
    url = "https://github.com/rebar/rebar/archive/${version}.tar.gz";
    sha256 = "01xxq1f1vrwca00pky2van26hi2hhr05ghfhy71v5cifzax4cwjp";
  };

  buildInputs = [ erlang ];

  buildPhase = "escript bootstrap";
  installPhase = ''
    mkdir -p $out/bin
    cp rebar $out/bin/rebar
  '';

  meta = {
    homepage = "https://github.com/rebar/rebar";
    description = "Erlang build tool that makes it easy to compile and test Erlang applications, port drivers and releases";

    longDescription = ''
      rebar is a self-contained Erlang script, so it's easy to
      distribute or even embed directly in a project. Where possible,
      rebar uses standard Erlang/OTP conventions for project
      structures, thus minimizing the amount of build configuration
      work. rebar also provides dependency management, enabling
      application writers to easily re-use common libraries from a
      variety of locations (git, hg, etc).
      '';

    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    maintainers = lib.teams.beam.members;
  };
}
