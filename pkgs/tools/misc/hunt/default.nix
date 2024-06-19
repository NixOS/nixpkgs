{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "hunt";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "LyonSyonII";
    repo = "hunt-rs";
    rev = "v${version}";
    sha256 = "sha256-NKXZECtepuFg6qTuXF9Gnat/vnrygt3UOZb0YUKPqi8=";
  };

  cargoHash = "sha256-ExwcFJVqQF/RTUyv1FvOCnlB+9Z7uhi/5UUjW7WcXTk=";

  meta = with lib; {
    description = "Simplified Find command made with Rust";
    homepage = "https://github.com/LyonSyonII/hunt-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "hunt";
  };
}
