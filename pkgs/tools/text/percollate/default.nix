{ lib, buildNpmPackage, fetchFromGitHub, chromium, makeWrapper }:

buildNpmPackage rec {
  pname = "percollate";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "danburzo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vGBGw9dUOSvSqM4WN53bb2LRduLjR6fW99C0ScdMVXk=";
  };

  npmDepsHash = "sha256-Qne4XjUmJS5e6x380CFY3Kd7/5coXHMxniMfqYIHQcQ=";

  dontNpmBuild = true;

  # Dev dependencies include an unnecessary Java dependency (epubchecker)
  # https://github.com/danburzo/percollate/blob/v4.2.1/package.json#L40
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
    description = "Command-line tool to turn web pages into readable PDF, EPUB, HTML, or Markdown docs";
    homepage = "https://github.com/danburzo/percollate";
    license = licenses.mit;
    maintainers = [ maintainers.austinbutler ];
    mainProgram = "percollate";
  };
}
