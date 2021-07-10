{ lib, stdenv, apacheHttpd, autoconf, automake, apr, aprutil, fetchFromGitHub, autoreconfHook }:
stdenv.mkDerivation rec {
  pname = "mod_tls";
  version = "0.8.1";
  src = fetchFromGitHub {
    owner = "abetterinternet";
    repo = "mod_tls";
    rev = "v${version}";
    sha256 = "0ficp42kqm474mxgla03yq5nhsy4hw824v9708g0bpgvm7zd2sfx";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ apacheHttpd apr aprutil autoconf automake ];

  configureFlags = [
    "--with-apxs=${apacheHttpd.dev}/bin/apxs"
  ];

  installPhase = ''
    mkdir -p $out/modules
    mv $out${apacheHttpd}/* $out
    rm -rf $out/nix
  '';

  meta = with lib; {
    homepage = "https://github.com/abetterinternet/mod_tls";
    description = "Bringing rustls into the Apache server.";
    license = licenses.asl20;
    maintainers = with maintainers; [ efx ];
    platforms = platforms.linux;
  };
}
