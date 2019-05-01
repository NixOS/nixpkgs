{ stdenv, lib, fetchFromGitHub, makeWrapper, php }: with lib; stdenv.mkDerivation rec {
  name = "icingaweb2-${version}";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "Icinga";
    repo = "icingaweb2";
    rev = "v${version}";
    sha256 = "0xcsf45m85d4ww5y2d5i73rjbp3hmc8lljc67lz9fl6f90y9gb22";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/share
    cp -ra application bin etc library modules public $out
    cp -ra doc $out/share

    wrapProgram $out/bin/icingacli --prefix PATH : "${makeBinPath [ php ]}"
  '';

  meta = {
    description = "Webinterface for Icinga 2";
    longDescription = ''
      A lightweight and extensible web interface to keep an eye on your environment.
      Analyse problems and act on them.
    '';
    homepage = "https://www.icinga.com/products/icinga-web-2/";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ das_j ];
  };
}
