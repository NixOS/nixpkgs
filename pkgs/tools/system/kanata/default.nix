{ lib
, rustPlatform
, fetchFromGitHub
, withCmd ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "kanata";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Tenh2LARajYAFHJ5gddeozY7rfySSvqFhudc/7b9cGg=";
  };

  cargoHash = "sha256-oJVGZhKJVK8q5lgK+G+KhVupOF05u37B7Nmv4rrI28I=";

  buildFeatures = lib.optional withCmd "cmd";

  postInstall = ''
    install -Dm 444 assets/kanata-icon.svg $out/share/icons/hicolor/scalable/apps/kanata.svg
  '';

  meta = with lib; {
    description = "A tool to improve keyboard comfort and usability with advanced customization";
    homepage = "https://github.com/jtroo/kanata";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ linj ];
    platforms = platforms.linux;
    mainProgram = "kanata";
  };
}
