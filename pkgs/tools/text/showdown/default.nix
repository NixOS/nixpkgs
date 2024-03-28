{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "showdown";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "showdownjs";
    repo = "showdown";
    rev = version;
    hash = "sha256-MTnCKDKrJWoR7xaep+oaWbAAzBEnwiqHaiTsmfhEOXQ=";
  };

  npmDepsHash = "sha256-xEXygjJVJvfKIoH8DIbELq5vUig5vyboBK5QSV5Zq2M=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "JavaScript Markdown to HTML converter";
    homepage = "https://showdownjs.com";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ rhoriguchi ];
  };
}
