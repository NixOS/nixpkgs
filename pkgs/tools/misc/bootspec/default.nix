{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "bootspec";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5IGSMHeL0eKfl7teDejAckYQjc8aeLwfwIQSzQ8YaAg=";
  };

  cargoHash = "sha256-eGSKVHjPnHK7WyGkO5LIjocNGHawahYQR3H5Lgk1C9s=";

  meta = with lib; {
    description = "Implementation of RFC-0125's datatype and synthesis tooling";
    homepage = "https://github.com/DeterminateSystems/bootspec";
    license = licenses.mit;
    maintainers = teams.determinatesystems.members;
    platforms = platforms.unix;
  };
}
