{ stdenv, autoreconfHook, which, writeText, makeWrapper, fetchFromGitHub, erlang
, z3, python }:

stdenv.mkDerivation rec {
  pname = "cuter";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "aggelgian";
    repo = "cuter";
    rev = "v${version}";
    sha256 = "1ax1pj6ji4w2mg3p0nh2lzmg3n9mgfxk4cf07pll51yrcfpfrnfv";
  };

  setupHook = writeText "setupHook.sh" ''
    addToSearchPath ERL_LIBS "$1/lib/erlang/lib/"
  '';

  nativeBuildInputs = [ autoreconfHook makeWrapper which ];
  buildInputs = [ python python.pkgs.setuptools z3.python erlang ];

  buildFlags = [ "PWD=$(out)/lib/erlang/lib/cuter-${version}" "cuter_target" ];
  configurePhase = ''
    autoconf
    ./configure --prefix $out
  '';

  installPhase = ''
    mkdir -p "$out/lib/erlang/lib/cuter-${version}"
    mkdir -p "$out/bin"
    cp -r * "$out/lib/erlang/lib/cuter-${version}"
    cp cuter "$out/bin/cuter"
    wrapProgram $out/bin/cuter \
      --prefix PATH : "${python}/bin" \
      --suffix PYTHONPATH : "${z3}/${python.sitePackages}" \
      --suffix ERL_LIBS : "$out/lib/erlang/lib"
  '';

  meta = {
    description = "A concolic testing tool for the Erlang functional programming language";
    license = stdenv.lib.licenses.gpl3;
    homepage = https://github.com/aggelgian/cuter;
    maintainers = with stdenv.lib.maintainers; [ ericbmerritt ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
