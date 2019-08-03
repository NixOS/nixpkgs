{ stdenv, fetchFromGitHub, autoreconfHook, libzip, boost, wt3, libconfig, pkgconfig } :

stdenv.mkDerivation rec {
  pname = "fileshelter";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "epoupon";
    repo = "fileshelter";
    rev = "v${version}";
    sha256 = "1n9hrls3l9gf8wfz6m9bylma1b1hdvdqsksv2dlp1zdgjdzv200b";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libzip boost wt3 libconfig ];

  NIX_LDFLAGS = [
    "-lpthread"
  ];

  postInstall = ''
    ln -s ${wt3}/share/Wt/resources $out/share/fileshelter/docroot/resources
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/epoupon/fileshelter;
    description = "FileShelter is a 'one-click' file sharing web application";
    maintainers = [ maintainers.willibutz ];
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
  };
}
