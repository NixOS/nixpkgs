{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "bunnyfetch";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Rosettea";
    repo = "bunnyfetch";
    rev = "v${version}";
    sha256 = "sha256-6MnjCXc9/8twdf8PHKsVJY1yWYwUf5R01vtQFJbyy7M=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-w+O1dU8t7uNvdlFnYhCdJCDixpWWZAnj9GrtsCbu9SM=";
=======
  vendorSha256 = "sha256-w+O1dU8t7uNvdlFnYhCdJCDixpWWZAnj9GrtsCbu9SM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # No upstream tests
  doCheck = false;

  meta = with lib; {
    description = "Tiny system info fetch utility";
    homepage = "https://github.com/Rosettea/bunnyfetch";
    license = licenses.mit;
    maintainers = with maintainers; [ devins2518 ];
    platforms = platforms.linux;
    mainProgram = "bunnyfetch";
  };
}
