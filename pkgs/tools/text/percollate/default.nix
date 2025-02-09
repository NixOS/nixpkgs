{ lib, buildNpmPackage, fetchFromGitHub, chromium, makeWrapper }:

buildNpmPackage rec {
  pname = "percollate";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "danburzo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Gl9v8WdntiatgxIvH1PZe3U9imGqdm5iYUx8gCwJhLw=";
  };

  npmDepsHash = "sha256-/HYnoMd+rriZ4WYGyM7g62Yii7lc/+ZKkc5QfPpFAQU=";

  dontNpmBuild = true;

  # Dev dependencies include an unnecessary Java dependency (epubchecker)
  # https://github.com/danburzo/percollate/blob/v4.0.4/package.json#L40
  npmInstallFlags = [ "--omit=dev" ];

  nativeBuildInputs = [ makeWrapper ];

  env = {
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = true;
  };

  postPatch = ''
    substituteInPlace package.json --replace "git config core.hooksPath .git-hooks" ""
  '';

  postInstall = ''
    wrapProgram $out/bin/percollate \
      --set PUPPETEER_EXECUTABLE_PATH ${chromium}/bin/chromium
  '';

  meta = with lib; {
    description = "A command-line tool to turn web pages into readable PDF, EPUB, HTML, or Markdown docs";
    homepage = "https://github.com/danburzo/percollate";
    license = licenses.mit;
    maintainers = [ maintainers.austinbutler ];
    mainProgram = "percollate";
  };
}
