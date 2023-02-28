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

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang
    "-Wno-implicit-function-declaration";

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
