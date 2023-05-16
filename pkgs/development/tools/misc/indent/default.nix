{ lib, stdenv, fetchurl, texinfo, buildPackages, pkgsStatic }:

stdenv.mkDerivation rec {
  pname = "indent";
  version = "2.2.12";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "12xvcd16cwilzglv9h7sgh4h1qqjd1h8s48ji2dla58m4706hzg7";
  };

  patches = [ ./darwin.patch ];
  makeFlags = [ "AR=${stdenv.cc.targetPrefix}ar" ];

  strictDeps = true;
  nativeBuildInputs = [ texinfo ];
  pkgsBuildBuild = [ buildPackages.stdenv.cc ]; # needed when cross-compiling

<<<<<<< HEAD
  env.NIX_CFLAGS_COMPILE = toString (
    lib.optional stdenv.cc.isClang "-Wno-implicit-function-declaration"
    ++ lib.optional (stdenv.cc.isClang && lib.versionAtLeast (lib.getVersion stdenv.cc) "13")  "-Wno-unused-but-set-variable"
  );
=======
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang
    "-Wno-implicit-function-declaration";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  hardeningDisable = [ "format" ];

  passthru.tests.static = pkgsStatic.indent;
  meta = {
    homepage = "https://www.gnu.org/software/indent/";
    description = "A source code reformatter";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.mmahut ];
    platforms = lib.platforms.unix;
  };
}
