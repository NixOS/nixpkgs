{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "discocss";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "mlvzk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-afmQCOOZ1MwQkbZZNHYfq2+IRv2eOtYBrGVHzDEbUHw=";
  };

  dontBuild = true;

  installPhase = ''
    install -Dm755 ./discocss $out/bin/discocss
  '';

  meta = with lib; {
    description = "A tiny Discord css-injector";
    changelog = "https://github.com/mlvzk/discocss/releases/tag/v${version}";
    homepage = "https://github.com/mlvzk/discocss";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mlvzk ];
  };
}
