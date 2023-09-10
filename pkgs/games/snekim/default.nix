{ lib, nimPackages, fetchFromGitea, raylib }:

nimPackages.buildNimPackage rec {
  pname = "snekim";
  version = "1.2.0";

  nimBinOnly = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "snekim";
    rev = "v${version}";
    sha256 = "sha256-Qgvq4CkGvNppYFpITCCifOHtVQYRQJPEK3rTJXQkTvI=";
  };

  strictDeps = true;

  buildInputs = [ nimPackages.nimraylib-now raylib ];

  nimFlags = [ "-d:nimraylib_now_shared" ];

  postInstall = ''
    install -D snekim.desktop -t $out/share/applications
    install -D icons/hicolor/48x48/snekim.svg -t $out/share/icons/hicolor/48x48/apps
  '';

  meta = with lib; {
    homepage = "https://codeberg.org/annaaurora/snekim";
    description = "A simple implementation of the classic snake game";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ annaaurora ];
  };
}
