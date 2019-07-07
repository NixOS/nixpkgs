{ stdenv, fetchurl, erlang }:


let
  version = "2.5.1";
in
stdenv.mkDerivation {
  name = "rebar-${version}";

  src = fetchurl {
    url = "https://github.com/rebar/rebar/archive/${version}.tar.gz";
    sha256 = "1y9b0smw0g5q197xf4iklzmcf8ad6w52p6mwzpf7b0ib1nd89jw6";
  };

  buildInputs = [ erlang ];

  buildPhase = "escript bootstrap";
  installPhase = ''
    mkdir -p $out/bin
    cp rebar $out/bin/rebar
  '';

  meta = {
    homepage = https://github.com/rebar/rebar;
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

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.the-kenny ];
    license = stdenv.lib.licenses.asl20;
  };
}
