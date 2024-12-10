{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "impl";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "josharian";
    repo = "impl";
    rev = "v${version}";
    hash = "sha256-a9jAoZp/wVnTyaE4l2yWSf5aSxXEtqN6SoxU68XhRhk=";
  };

  vendorHash = "sha256-vTqDoM/LK5SHkayLKYig+tCrXLelOoILmQGCxlTWHog=";

  meta = with lib; {
    description = "Generate method stubs for implementing an interface";
    mainProgram = "impl";
    homepage = "https://github.com/josharian/impl";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
