{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  tcl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rl_json";
  version = "0.15.7";

  src = fetchFromGitHub {
    owner = "RubyLane";
    repo = "rl_json";
    tag = finalAttrs.version;
    hash = "sha256-6Y6bq/Lm6KCFFV3RF6v4fVPEN1LO+jE2xZV50a8zyng=";
    fetchSubmodules = true;
  };

  # The vendored libtommath conflicts with tclTomMath.
  # Replacing it with tclTomMath fixes the issue.
  # https://github.com/RubyLane/rl_json/issues/57
  # The switch to a vendored libtommath was done in 0.15.4 in commit
  # https://github.com/RubyLane/rl_json/commit/9294d533f4d81288acf53045666b1587cf7fbf92
  # "for proper bignum handling", but the commit message doesn't explain what's wrong
  # with tclTomMath's bignum handling and all tests pass anyway.
  postPatch = ''
    rm -r deps/libtommath
    substituteInPlace Makefile.in \
      --replace-fail 'deps: local/lib/libtommath.a' 'deps:'
    substituteInPlace configure.ac \
      --replace-fail -ltommath ""
    substituteInPlace generic/rl_jsonInt.h \
      --replace-fail '#include <tommath.h>' '#include <tclTomMath.h>'
  '';

  nativeBuildInputs = [
    autoreconfHook
    tcl.tclPackageHook
  ];

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--libdir=${placeholder "out"}/lib"
    "--includedir=${placeholder "out"}/include"
    "--datarootdir=${placeholder "out"}/share"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

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
