<<<<<<< HEAD
{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
=======
{ buildGoModule
, fetchFromGitHub
, lib, stdenv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "monsoon";
<<<<<<< HEAD
  version = "0.8.0";
=======
  version = "0.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "RedTeamPentesting";
    repo = "monsoon";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-7cfy8dYhiReFVz10wui3qqxlXOX7wheREkvSnj2KyOw=";
  };

  vendorHash = "sha256-SZDX61iPwT/mfxJ+n2nlvzgEvUu6h3wVkmeqZtxQ9KE=";

  # Tests fails on darwin
=======
    rev = "v${version}";
    sha256 = "sha256-eXzD47qFkouYJkqWHbs2g2pbl3I7vWgIU6TqN3MEYQI=";
  };

  vendorSha256 = "sha256-tG+qV4Q77wT6x8y5cjZUaAWpL//sMUg1Ce3jS/dXF+Y=";

  # tests fails on darwin
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Fast HTTP enumerator";
    longDescription = ''
      A fast HTTP enumerator that allows you to execute a large number of HTTP
      requests, filter the responses and display them in real-time.
    '';
    homepage = "https://github.com/RedTeamPentesting/monsoon";
<<<<<<< HEAD
    changelog = "https://github.com/RedTeamPentesting/monsoon/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
