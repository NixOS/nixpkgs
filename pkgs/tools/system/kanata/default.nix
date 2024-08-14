{ stdenv
, lib
, darwin
, rustPlatform
, fetchFromGitHub
, withCmd ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "kanata";
  version = "1.7.0-prerelease-1";

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-eDeGVmh1gI/DhiP6gxJyGH9G9LNH1NHW0+DNuOPUnBY=";
  };

  cargoHash =
    if stdenv.isLinux
    then "sha256-gRJdfvb3Q+G7pXpOyKrgozrZPJJbDajC63Kk5QtgX00="
    else "sha256-i9eY8dvteOLYmM+ad1nw+fohec2SPGCGqColXNamEBo=";

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
