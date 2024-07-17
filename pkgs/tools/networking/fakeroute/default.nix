{
  lib,
  stdenv,
  fetchurl,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "fakeroute";
  version = "0.3";

  src = fetchurl {
    url = "https://maxwell.ydns.eu/git/rnhmjoj/fakeroute/releases/download/v${version}/fakeroute-${version}.tar.gz";
    hash = "sha256-DoXGJm8vOlAD6ZuvVAt6bkgfahc8WgyYIXCrgqzfiWg=";
  };

  passthru.tests.fakeroute = nixosTests.fakeroute;

  meta = with lib; {
    description = ''
      Make your machine appears to be anywhere on the internet in a traceroute
    '';
    homepage = "https://maxwell.ydns.eu/git/rnhmjoj/fakeroute";
    license = licenses.bsd3;
    platforms = platforms.linux;
    mainProgram = "fakeroute";
  };
}
