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
    tag = "v${version}";
    hash = "sha256-/DYKjhHjfXPWpU1RFmRUbartSxIBgVP59nbgwKMd0jg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-QVS+b/mH7hnzaZjnGg8rw6k11uOuKGFeiPoXyqwD8tk=";

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
