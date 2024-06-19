{ lib
, rustPlatform
, fetchFromGitLab
}:

rustPlatform.buildRustPackage {
  pname = "dotacat";
  version = "v0.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.scd31.com";
    owner = "stephen";
    repo = "dotacat";
    rev = "f3b7e7816bed6b84123e066c57cf4003d77a85f1";
    hash = "sha256-y+u9PO01W+IzBatGHZpgOD7cRKjdeuy4/VX7/V9cu3Q=";
  };

  cargoHash = "sha256-ilvsqwvfQejo453veSZ5VMP8XhL7NryrDh+rYJkXk30=";

  meta = with lib; {
    description = "Like lolcat, but fast";
    homepage = "https://gitlab.scd31.com/stephen/dotacat";
    license = licenses.mit;
    maintainers = with maintainers; [ traxys ];
    mainProgram = "dotacat";
  };
}
