{ stdenv, fetchurl, libpng, perl, perlPackages, makeWrapper }:

stdenv.mkDerivation rec {
  name = "icoutils-0.32.2";

  src = fetchurl {
    url = "mirror://savannah/icoutils/${name}.tar.bz2";
    sha256 = "1g8ihxw24gbiy189h36w16lbyfq7fn260qkbc85n9jqrvkxsz4p8";
  };

  buildInputs = [ makeWrapper libpng perl ];
  propagatedBuildInputs = [ perlPackages.LWP ];

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
    homepage = http://www.nongnu.org/icoutils/;
    description = "Set of programs to deal with Microsoft Windows(R) icon and cursor files";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
