<<<<<<< HEAD
{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl }:
=======
{ lib, rustPlatform, fetchFromGitHub, pkg-config, stdenv, openssl }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

rustPlatform.buildRustPackage rec {
  pname = "todo";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "sioodmy";
    repo = "todo";
    rev = version;
    sha256 = "oyRdXvVnCfdFM8lI1eCDHHYNWcJc0Qg0TKxQXUqNo40=";
  };

  cargoSha256 = "B0tecuBx/FFQokhfI6+xpppyG5DD8WS2+MkmPaZfMhI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];
  meta = with lib; {
    description = "Simple todo cli program written in rust";
    homepage = "https://github.com/sioodmy/todo";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sioodmy ];
    mainProgram = "todo";
  };
}
