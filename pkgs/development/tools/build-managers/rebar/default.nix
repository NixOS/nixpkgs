{ stdenv, fetchurl, erlang }:

stdenv.mkDerivation {
  name = "rebar-2.1.0-pre";

  src = fetchurl {
    url = "https://github.com/basho/rebar/archive/2.1.0-pre.tar.gz";
    sha256 = "0dsbk9ssvk1hx9275900dg4bz79kpwcid4gsz09ziiwzv0jjbrjn";
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

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.the-kenny ];
  };
}
