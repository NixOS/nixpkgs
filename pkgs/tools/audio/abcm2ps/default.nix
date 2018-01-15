{ stdenv, fetchFromGitHub, pkgconfig, which, freetype, pango }:

stdenv.mkDerivation rec {
  name = "abcm2ps-${version}";
  version = "8.13.18";

  src = fetchFromGitHub {
    owner = "leesavide";
    repo = "abcm2ps";
    rev = "v${version}";
    sha256 = "0fzhk43fidyflqj8wd7m3m4pibzrbr1c120xi9wskzb3627pgyh1";
  };

  prePatch = ''
    chmod +x configure
  '';

  configureFlags = [
    "--INSTALL=install"
  ];

  buildInputs = [ which pkgconfig freetype pango ];

  meta = with stdenv.lib; {
    homepage = http://moinejf.free.fr/;
    license = licenses.gpl3;
    description = "abcm2ps is a command line program which converts ABC to music sheet in PostScript or SVG format";
    maintainers = [ maintainers.dotlambda ];
  };
}
