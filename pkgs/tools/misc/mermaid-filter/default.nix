{ lib
, buildNpmPackage
, fetchFromGitHub
, makeWrapper
, chromium
}:

buildNpmPackage rec {
  pname = "mermaid-filter";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "raghur";
    repo = "mermaid-filter";
    rev = "v${version}";
    hash = "sha256-5MKiUeiqEeWicOIdqOJ22x3VswYKiK4RSxZRzJntO6M=";
  };

  npmDepsHash = "sha256-pnylo3dPgj7aD5czTWSV+uP5Cj8rVAsjZYoJ/WPRuuc=";

  nativeBuildInputs = [ makeWrapper ];

  env.PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = 1;

  dontNpmBuild = true;

  postInstall = ''
    wrapProgram $out/bin/mermaid-filter \
      --set PUPPETEER_EXECUTABLE_PATH ${chromium}/bin/chromium
  '';

  meta = with lib; {
    description = "Pandoc filter for creating diagrams in mermaid syntax blocks in markdown docs";
    homepage = "https://github.com/raghur/mermaid-filter";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ners ];
    platforms = chromium.meta.platforms;
    mainProgram = "mermaid-filter";
  };
}
