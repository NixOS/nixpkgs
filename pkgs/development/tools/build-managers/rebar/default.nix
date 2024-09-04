{ lib, stdenv, fetchFromGitHub, erlang }:

stdenv.mkDerivation rec {
  pname = "rebar";
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "rebar";
    repo = "rebar";
    rev = version;
    sha256 = "sha256-okvG7X2uHtZ1p+HUoFOmslrWvYjk0QWBAvAMAW2E40c=";
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
    mainProgram = "rebar";

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
