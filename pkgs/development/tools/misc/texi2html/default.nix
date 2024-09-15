{ lib, stdenv, fetchurl, perl, gettext, buildPackages }:

stdenv.mkDerivation rec {
  pname = "texi2html";
  version = "5.0";

  src = fetchurl {
    url = "mirror://savannah/texi2html/${pname}-${version}.tar.bz2";
    sha256 = "1yprv64vrlcbksqv25asplnjg07mbq38lfclp1m5lj8cw878pag8";
  };

  strictDeps = true;

  nativeBuildInputs = [ gettext perl ];
  buildInputs = [ perl ];

  postPatch = ''
    patchShebangs separated_to_hash.pl
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    for f in $out/bin/*; do
      substituteInPlace $f --replace "${buildPackages.perl}" "${perl}"
    done
  '';

  meta = with lib; {
    description = "Perl script which converts Texinfo source files to HTML output";
    mainProgram = "texi2html";
    homepage = "https://www.nongnu.org/texi2html/";
    license = licenses.gpl2;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.unix;
  };
}
