{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  tcl,
  pandoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rl_json";
  version = "0.16";

  src = fetchFromGitHub {
    owner = "RubyLane";
    repo = "rl_json";
    tag = finalAttrs.version;
    hash = "sha256-rXr7x9Cr+gD938+NEPguvYVWH5s9bKccMobuZsb0IQY=";
    fetchSubmodules = true;
  };

  postPatch = ''
    mkdir doc/.build
    cp doc/json.md.in doc/.build/json.md.in
  '';

  nativeBuildInputs = [
    autoreconfHook
    tcl.tclPackageHook
    pandoc
  ];

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--libdir=${placeholder "out"}/lib"
    "--includedir=${placeholder "out"}/include"
    "--datarootdir=${placeholder "out"}/share"
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/RubyLane/rl_json";
    description = "Tcl extension for fast json manipulation";
    license = lib.licenses.tcltk;
    longDescription = ''
      Extends Tcl with a json value type and a command to manipulate json values
      directly. Similar in spirit to how the dict command manipulates dictionary
      values, and comparable in speed.
    '';
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = tcl.meta.platforms;
    # From version 0.15.1: 'endian.h' file not found
    broken = stdenv.hostPlatform.isDarwin;
  };
})
