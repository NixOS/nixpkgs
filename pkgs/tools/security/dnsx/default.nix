<<<<<<< HEAD
{ lib
, buildGoModule
, fetchFromGitHub
=======
{ buildGoModule
, fetchFromGitHub
, lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "dnsx";
<<<<<<< HEAD
  version = "1.1.4";
=======
  version = "1.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "dnsx";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-FNPAsslKmsLrUtiw+GlXLppsEk/VB02jkZLmrB8zZOI=";
  };

  vendorHash = "sha256-QXmy+Ph0lKguAoIWfc41z7XH7jXGc601DD6v292Hzj0=";

  # Tests require network access
  doCheck = false;
=======
    rev = "v${version}";
    sha256 = "sha256-5ZWBUgW3esdH+9APU5Z9Hn9VtA6VQqvUfJp5C42791k=";
  };

  vendorSha256 = "sha256-71JqgJZyx+9NTw08D7V5PPc84ExjGYdieCvFPTDSrs8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Fast and multi-purpose DNS toolkit";
    longDescription = ''
      dnsx is a fast and multi-purpose DNS toolkit allow to run multiple
      probers using retryabledns library, that allows you to perform
      multiple DNS queries of your choice with a list of user supplied
      resolvers.
    '';
    homepage = "https://github.com/projectdiscovery/dnsx";
<<<<<<< HEAD
    changelog = "https://github.com/projectdiscovery/dnsx/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
