{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "faketty";
  version = "1.0.17";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-JUvQg8WLk5+O+3fbbQSUW6Mtp9TrYlrt+uwMAzm082Q=";
  };

  cargoHash = "sha256-Y+jcq2twIGDbHTA6aBGnyN9Old993Y/2j/fKnXhZGYU=";

  postPatch = ''
    patchShebangs tests/test.sh
  '';

  meta = with lib; {
    description = "Wrapper to execute a command in a pty, even if redirecting the output";
    homepage = "https://github.com/dtolnay/faketty";
    changelog = "https://github.com/dtolnay/faketty/releases/tag/${version}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "faketty";
  };
}
