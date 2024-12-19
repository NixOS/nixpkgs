{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "jsonwatch";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "dbohdan";
    repo = "jsonwatch";
    rev = "refs/tags/v${version}";
    hash = "sha256-/DYKjhHjfXPWpU1RFmRUbartSxIBgVP59nbgwKMd0jg=";
  };

  cargoHash = "sha256-Io51qbZOVcOKyMvo9/GTPXkGiJwjxcIPK3y7vAuTJOM=";

  meta = with lib; {
    description = "Like watch -d but for JSON";
    longDescription = ''
      jsonwatch is a command line utility with which you can track
      changes in JSON data delivered by a shell command or a web
      (HTTP/HTTPS) API. jsonwatch requests data from the designated
      source repeatedly at a set interval and displays the
      differences when the data changes.
    '';
    homepage = "https://github.com/dbohdan/jsonwatch";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "jsonwatch";
  };
}
