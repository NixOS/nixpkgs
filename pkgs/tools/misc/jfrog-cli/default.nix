<<<<<<< HEAD
{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jfrog-cli";
  version = "2.46.2";
=======
{ buildGoModule, fetchFromGitHub, pkgs, lib }:

buildGoModule rec {
  pname = "jfrog-cli";
  version = "2.37.1";
  vendorHash = "sha256-e+lD3VeGccOlL+zYBE0DLMyDrrQmG956HTfS5Wf7eps=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-NPRxBcXnY1l30RrFTgR+vqvRLdH564Daw/OIqRUhTss=";
  };

  vendorHash = "sha256-dMVXpqIDL6fQc9KYN4Co6vBCrpxocnwA3EkgMEme3aI=";

=======
    rev = "v${version}";
    sha256 = "sha256-3RJzWBoKjzRrEVhOdu+oamIfHEPgJupVzU8KqMlSDbA=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postInstall = ''
    # Name the output the same way as the original build script does
    mv $out/bin/jfrog-cli $out/bin/jf
  '';

  # Some of the tests require a writable $HOME
  preCheck = "export HOME=$TMPDIR";

  meta = with lib; {
    homepage = "https://github.com/jfrog/jfrog-cli";
    description = "Client for accessing to JFrog's Artifactory and Mission Control through their respective REST APIs";
<<<<<<< HEAD
    changelog = "https://github.com/jfrog/jfrog-cli/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "jf";
    maintainers = with maintainers; [ detegr ];
=======
    license = licenses.asl20;
    mainProgram = "jf";
    maintainers = [ maintainers.detegr ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
