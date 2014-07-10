{ stdenv, fetchurl, erlang }:


let
  version = "2.5.0";
in
stdenv.mkDerivation {
  name = "rebar-${version}";

  src = fetchurl {
    url = "https://github.com/rebar/rebar/archive/${version}.tar.gz";
    sha256 = "1gnc8l997ys13glknl4r7hxfvgis8axn89sms8bn1ijrgx6gm1fm";
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

    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.the-kenny ];
  };
}
