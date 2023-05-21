{ buildGoModule, fetchFromGitHub, pkgs, lib }:

buildGoModule rec {
  pname = "jfrog-cli";
  version = "2.37.3";
  vendorHash = "sha256-W/Us8OTbaJismGkKashZoM1wkHXpHv/TxrwT86HaiU8=";

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
    rev = "v${version}";
    sha256 = "sha256-ic6Q/1BJIYe/LajW389vL7Gaodz/EFLEGkZl6QSIvbo=";
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
