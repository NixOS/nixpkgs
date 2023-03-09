{ buildGoModule, fetchFromGitHub, pkgs, lib }:

buildGoModule rec {
  pname = "jfrog-cli";
  version = "2.34.6";
  vendorHash = "sha256-EhdE94djk/Or5K4BZtJ3NPNPWt5lODV10zgYWfZ/4OI=";

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
    rev = "v${version}";
    sha256 = "sha256-d2kEl2zT0vlcjii5V54oWE1TIKPPEUuCbvrrjPMme3E=";
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
