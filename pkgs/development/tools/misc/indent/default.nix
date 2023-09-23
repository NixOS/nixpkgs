{ lib
, stdenv
, fetchurl
, fetchpatch
, libintl
, texinfo
, buildPackages
, pkgsStatic
}:

stdenv.mkDerivation rec {
  pname = "indent";
  version = "2.2.13";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-nmRjT8TOZ5eyBLy4iXzhT90KtIyldpb3h2fFnK5XgJU=";
  };

  makeFlags = [ "AR=${stdenv.cc.targetPrefix}ar" ];

  strictDeps = true;
  nativeBuildInputs = [ texinfo ];
  buildInputs = [ libintl ];
  pkgsBuildBuild = [ buildPackages.stdenv.cc ]; # needed when cross-compiling

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optional stdenv.cc.isClang "-Wno-implicit-function-declaration"
    ++ lib.optional (stdenv.cc.isClang && lib.versionAtLeast (lib.getVersion stdenv.cc) "13")  "-Wno-unused-but-set-variable"
  );

  hardeningDisable = [ "format" ];

  doCheck = true;

  passthru.tests.static = pkgsStatic.indent;
  meta = {
    homepage = "https://www.gnu.org/software/indent/";
    description = "A source code reformatter";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.mmahut ];
    platforms = lib.platforms.unix;
  };
}
