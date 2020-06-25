{ stdenv }:

stdenv.mkDerivation rec {
  name = "ufetch-nixos";
  src = ./ufetch-nixos;

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out
    cp ${src} $out
  '';

  meta = with stdenv.lib; {
    description = "Tiny system info for NixOS";
    homepage = "https://gitlab.com/jschx/-/blob/master/ufetch-nixos";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ vulcoes ];
  };
}

