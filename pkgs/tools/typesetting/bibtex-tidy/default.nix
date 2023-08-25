{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "bibtex-tidy";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "FlamingTempura";
    repo = "bibtex-tidy";
    rev = "v${version}";
    hash = "sha256-VjQuMQr3OJgjgX6FdH/C4mehf8H7XjDZ9Rxs92hyQVo=";
  };

  patches = [
    # downloads Google fonts during `npm run build`
    ./remove-google-font-loader.patch
  ];

  npmDepsHash = "sha256-u2lyG95F00S/bvsVwu0hIuUw2UZYQWFakCF31LIijSU=";

  env = {
    PUPPETEER_SKIP_DOWNLOAD = true;
  };

  meta = {
    changelog = "https://github.com/FlamingTempura/bibtex-tidy/blob/${src.rev}/CHANGELOG.md";
    description = "Cleaner and Formatter for BibTeX files";
    homepage = "https://github.com/FlamingTempura/bibtex-tidy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bertof ];
  };
}
