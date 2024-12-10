{
  buildGoPackage,
  fetchFromGitHub,
  lib,
}:

buildGoPackage rec {
  pname = "allmark";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "andreaskoch";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JfNn/e+cSq1pkeXs7A2dMsyhwOnh7x2bwm6dv6NOjLU=";
  };

  goPackagePath = "github.com/andreaskoch/allmark";

  postInstall = ''
    mv $out/bin/{cli,allmark}
  '';

  meta = with lib; {
    description = "A cross-platform markdown web server";
    homepage = "https://github.com/andreaskoch/allmark";
    changelog = "https://github.com/andreaskoch/allmark/-/releases/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ urandom ];
    mainProgram = "allmark";
  };
}
