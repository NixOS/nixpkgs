{ buildGoModule, fetchFromGitHub, pkgs, lib }:

buildGoModule rec {
  pname = "jfrog-cli";
  version = "2.34.1";
  vendorHash = "sha256-0C2uUq8GKM3IMjhH30Fa702uDmXbVbEDWJ6wKIWYTQw=";

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
    rev = "v${version}";
    sha256 = "sha256-7jkhr6fav7YwwFyO3m6mj2jl3RoX3sbS4YBBeMT/Go8=";
  };

  postInstall = ''
    # Name the output the same way as the original build script does
    mv $out/bin/jfrog-cli $out/bin/jf
  '';

  # Some of the tests require a writable $HOME
  preCheck = "export HOME=$TMPDIR";

  meta = with lib; {
    homepage = "https://github.com/jfrog/jfrog-cli";
    description = "Client for accessing to JFrog's Artifactory and Mission Control through their respective REST APIs";
    license = licenses.asl20;
    mainProgram = "jf";
    maintainers = [ maintainers.detegr ];
  };
}
