{ buildGoModule, fetchFromGitHub, pkgs, lib }:

buildGoModule rec {
  pname = "jfrog-cli";
  version = "2.35.0";
  vendorHash = "sha256-vOYfm6V1SyfhT7gX/Nk01hD/Txwh5UXCorzi6Jfl9I8=";

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
    rev = "v${version}";
    sha256 = "sha256-kaPGVNS+h+kZjG7+GupRxn6ypUfIU4BefPEl6QNA4cE=";
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
