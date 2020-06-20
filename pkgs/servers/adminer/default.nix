{ stdenv, libbsd, fetchurl, phpPackages, php }:

stdenv.mkDerivation rec {
  version = "4.7.7";
  pname = "adminer";

  # not using fetchFromGitHub as the git repo relies on submodules that are included in the tar file
  src = fetchurl {
    url = "https://github.com/vrana/adminer/releases/download/v${version}/adminer-${version}.tar.gz";
    sha256 = "1rvvc7xml7ycpbpjgqbgkan8djplx67balrmfignk1b6h9cw3l4q";
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
