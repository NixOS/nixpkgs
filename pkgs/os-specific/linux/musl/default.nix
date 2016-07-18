{ stdenv, fetchurl, cross ? null, gccCross ? null }:

stdenv.mkDerivation rec {
  name    = "musl-${version}${stdenv.lib.optionalString (cross != null) ''-${cross.arch}''}";
  version = "1.1.14";

  src = fetchurl {
    url    = "http://www.musl-libc.org/releases/musl-${version}.tar.gz";
    sha256 = "1ddral87srzk741cqbfrx9aygnh8fpgfv7mjvbain2d6hh6c1xim";
  };

  buildInputs = stdenv.lib.optional (gccCross != null) gccCross;
  CROSS_COMPILE = stdenv.lib.optionalString (cross != null) "${cross.config}-";

  preConfigure = ''
    configureFlagsArray+=("--syslibdir=$out/lib")
    ${stdenv.lib.optionalString (gccCross != null) ''export CC="${cross.config}-gcc"''}
  '';

  configureFlags = [
    "--enable-shared"
    "--enable-static"
    "--disable-gcc-wrapper"
  ] ++ stdenv.lib.optional (cross != null) "--target=${cross.arch}";

  outputs = ["dev" "out"];
  enableParallelBuilding = true;
  dontDisableStatic = true;
  dontSetConfigureCross = true;
  dontStrip = true;
  dontCrossStrip = true;

  passthru = {
    # isMusl can be dropped when/if providing the dynamicLinker
    # name through the libc is adopted
    isMusl = true;
    dynamicLinker = "libc.so";
  };

  meta = {
    description = "An efficient, small, quality libc implementation";
    homepage    = "http://www.musl-libc.org";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ dvc94ch thoughtpolice ];
  };
}
