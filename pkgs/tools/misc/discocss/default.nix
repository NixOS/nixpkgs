{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "discocss";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "mlvzk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EdkcTVDFQppBeAoyM5hMMIK0d4B87JyVlmCW7zlGfDs=";
  };

  dontBuild = true;

  installPhase = ''
    install -m755 -D ./discocss $out/bin/discocss
  '';

  meta = with lib; {
    description = "A tiny Discord css-injector";
    homepage = "https://github.com/mlvzk/discocss";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mlvzk ];
  };
}
