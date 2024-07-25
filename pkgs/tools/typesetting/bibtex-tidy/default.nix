{ lib
, buildNpmPackage
, fetchFromGitHub
, testers
, bibtex-tidy
}:

buildNpmPackage rec {
  pname = "bibtex-tidy";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "FlamingTempura";
    repo = "bibtex-tidy";
    rev = "9658d907d990fd80d25ab37d9aee120451bf5d19";
    hash = "sha256-4TrEabxIVB0Vu/E1ClKwk7lXcnPgoVh3RjLYsPwH2yQ=";
  };

  npmDepsHash = "sha256-VzzHGmW7Rb6dEdBxd84GXKSPasqfTkn+5rNw9C2lt8k=";

  env = {
    PUPPETEER_SKIP_DOWNLOAD = true;
  };

  passthru.tests = {
    version = testers.testVersion {
      package = bibtex-tidy;
      version = "v${version}";
    };
  };

  meta = {
    changelog = "https://github.com/FlamingTempura/bibtex-tidy/blob/${src.rev}/CHANGELOG.md";
    description = "Cleaner and Formatter for BibTeX files";
    mainProgram = "bibtex-tidy";
    homepage = "https://github.com/FlamingTempura/bibtex-tidy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bertof ];
  };
}
