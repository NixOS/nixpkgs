{ lib, fetchFromGitHub, makeWrapper, mkYarnPackage, chromium }:

mkYarnPackage rec {
  pname = "asciidoctor-web-pdf";
  version = "1.0.0-alpha.14";

  src = fetchFromGitHub {
    owner = "Mogztter";
    repo = pname;
    rev = "v${version}";
    sha256 = "Q6udI/S9pT1Y3TsVW2C4slP/fL52s8wG/X10QArlhCA=";
  };

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/asciidoctor-web-pdf \
      --set PUPPETEER_EXECUTABLE_PATH ${chromium}/bin/chromium
    wrapProgram $out/bin/asciidoctor-pdf \
      --set PUPPETEER_EXECUTABLE_PATH ${chromium}/bin/chromium
  '';

  meta = with lib; {
    homepage = "https://github.com/Mogztter/asciidoctor-web-pdf";
    description = "Convert AsciiDoc documents to PDF using web technologies";
    license = licenses.mit;
    maintainers = with maintainers; [ Flakebi ];
  };
}
