{ stdenv, fetchurl, erlang }:


let
  version = "3.0.0-beta.4";
in
stdenv.mkDerivation {
  name = "rebar3-${version}";

  src = fetchurl {
    url = "https://github.com/rebar/rebar3/archive/${version}.tar.gz";
    sha256 = "0px66scjdia9aaa5z36qzxb848r56m0k98g0bxw065a2narsh4xy";
  };

  buildInputs = [ erlang ];

  buildPhase = ''
    HOME=. escript bootstrap
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp rebar3 $out/bin/rebar3
  '';

  meta = {
    homepage = "https://github.com/rebar/rebar3";
    description = "rebar 3.0 is an Erlang build tool that makes it easy to compile and test Erlang applications, port drivers and releases.";

    longDescription = ''
      rebar is a self-contained Erlang script, so it's easy to distribute or
      even embed directly in a project. Where possible, rebar uses standard
      Erlang/OTP conventions for project structures, thus minimizing the amount
      of build configuration work. rebar also provides dependency management,
      enabling application writers to easily re-use common libraries from a
      variety of locations (hex.pm, git, hg, and so on).
      '';

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.gleber ];
  };
}
