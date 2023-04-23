{ lib, stdenv, fetchurl, libpng, perl, perlPackages, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "icoutils";
  version = "0.32.3";

  src = fetchurl {
    url = "mirror://savannah/icoutils/icoutils-${version}.tar.bz2";
    sha256 = "1q66cksms4l62y0wizb8vfavhmf7kyfgcfkynil3n99s0hny1aqp";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ libpng perl ];
  propagatedBuildInputs = [ perlPackages.LWP ];

  # Fixes a build failure on aarch64-darwin. Define for all Darwin targets for when x86_64-darwin
  # upgrades to a newer SDK.
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-DTARGET_OS_IPHONE=0";

  patchPhase = ''
    patchShebangs extresso/extresso
    patchShebangs extresso/extresso.in
    patchShebangs extresso/genresscript
    patchShebangs extresso/genresscript.in
  '';

  preFixup = ''
    wrapProgram $out/bin/extresso --prefix PERL5LIB : $PERL5LIB
    wrapProgram $out/bin/genresscript --prefix PERL5LIB : $PERL5LIB
  '';

  meta = {
    homepage = "https://www.nongnu.org/icoutils/";
    description = "Set of programs to deal with Microsoft Windows(R) icon and cursor files";
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; linux ++ darwin;
  };
}
