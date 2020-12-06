{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "discocss";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "mlvzk";
    repo = pname;
    rev = "v${version}";
    sha256 = "1818jca3sw2ngw1n488q82w5rakx4cxgknnkmsaa0sz4h8gldfy8";
  };

  dontBuild = true;

  installPhase = ''
    install -m755 -D ./discocss $out/bin/discocss
  '';

  meta = with lib; {
    description = "A tiny Discord css-injector";
    homepage = "https://github.com/mlvzk/discocss";
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mlvzk ];
  };
}
