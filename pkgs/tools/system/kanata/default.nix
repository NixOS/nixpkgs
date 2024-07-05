{ stdenv
, lib
, darwin
, rustPlatform
, fetchFromGitHub
, withCmd ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "kanata";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Kuxy6lGzImYYujuJwZZdfuu3X7/PJNOJefeZ0hVJaAA=";
  };

  cargoHash =
    if stdenv.isLinux
    then "sha256-R2lHg+I8Sry3/n8vTfPpDysKCKMDUvxyMKRhEQKDqS0="
    else "sha256-9CXrOP6SI+sCD9Q94N8TlRB/h+F/l7t3zHbtVDqddS4=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.IOKit ];

  buildFeatures = lib.optional withCmd "cmd";

  postInstall = ''
    install -Dm 444 assets/kanata-icon.svg $out/share/icons/hicolor/scalable/apps/kanata.svg
  '';

  meta = with lib; {
    description = "Tool to improve keyboard comfort and usability with advanced customization";
    homepage = "https://github.com/jtroo/kanata";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ bmanuel linj ];
    platforms = platforms.unix;
    mainProgram = "kanata";
    broken = stdenv.isDarwin;
  };
}
