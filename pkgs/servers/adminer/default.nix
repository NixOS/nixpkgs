{ stdenv, libbsd, fetchurl, phpPackages, php }:

stdenv.mkDerivation rec {
  version = "4.7.6";
  pname = "adminer";

  # not using fetchFromGitHub as the git repo relies on submodules that are included in the tar file
  src = fetchurl {
    url = "https://github.com/vrana/adminer/releases/download/v${version}/adminer-${version}.tar.gz";
    sha256 = "1zgvscz7jk32qga8hp2dg89h7y72v05vz4yh4lq2ahhwwkbnsxpi";
  };

  nativeBuildInputs = with phpPackages; [ php composer ];

  buildPhase = ''
    composer --no-cache run compile
  '';

  installPhase = ''
    mkdir $out
    cp adminer-${version}.php $out/adminer.php
  '';

  meta = with stdenv.lib; {
    description = "Database management in a single PHP file";
    homepage = "https://www.adminer.org";
    license = with licenses; [ asl20 gpl2 ];
    maintainers = with maintainers; [ sstef ];
    platforms = platforms.all;
  };
}
