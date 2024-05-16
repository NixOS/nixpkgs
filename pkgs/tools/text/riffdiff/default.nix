{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = version;
    hash = "sha256-wBLVH4Yrvj3rU5tRaxV8BBWkR2xLMxjkwjJ4rf1hHXk=";
  };

  cargoHash = "sha256-4qskpcDE9l+7KjcVRou4GcdG7aF8stKXK12WBy81UBw=";

  meta = with lib; {
    description = "A diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    license = licenses.mit;
    maintainers = with maintainers; [ johnpyp ];
    mainProgram = "riff";
  };
}
