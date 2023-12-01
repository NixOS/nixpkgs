{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "pwnat";
  # Latest release has an annoying segmentation fault bug, see:
  # https://github.com/samyk/pwnat/pull/25 . Merging only #25 is impossible due
  # to major code refactoring.
  version = "2023-03-31";

  src = fetchFromGitHub {
    owner  = "samyk";
    repo   = pname;
    rev    = "8ec62cdae53a2d573c9f9c906133ca45bbd3360a";
    sha256 = "sha256-QodNw3ab8/TurKamg6AgMfQ08aalp4j6q663B+sWmRM=";
  };

  # See https://github.com/samyk/pwnat/issues/28
  preBuild = ''
    mkdir obj
  '';

  installPhase = ''
    runHook preInstall

    install -D pwnat $out/bin/pwnat

    runHook postInstall
  '';

  meta = with lib; {
    homepage    = "http://samy.pl/pwnat/";
    description = "ICMP NAT to NAT client-server communication";
    license     = lib.licenses.gpl3Plus;
    maintainers = with maintainers; [viric];
    platforms   = with platforms; linux;
  };
}
