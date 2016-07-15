{ stdenv, fetchurl, libpng, perl, perlPackages, makeWrapper }:

stdenv.mkDerivation rec {
  name = "icoutils-0.31.0";

  src = fetchurl {
    url = "mirror://savannah/icoutils/${name}.tar.bz2";
    sha256 = "0wdgyfb1clrn3maq84vi4vkwjydy72p5hzk6kb9nb3a19bbxk5d8";
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
    platforms = with stdenv.lib.platforms; linux;
  };
}
