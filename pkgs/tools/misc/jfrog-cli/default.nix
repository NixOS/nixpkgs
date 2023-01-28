{ buildGoModule, fetchFromGitHub, pkgs, lib }:

buildGoModule rec {
  pname = "jfrog-cli";
  version = "2.32.0";
  vendorSha256 = "sha256-nL+2Yc4gI2+SoxoaGlazecsrcVkVh6Ig9sqITSOa5e0=";

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
    rev = "v${version}";
    sha256 = "sha256-EyDX4OrBAzc5eYR660SrGIG61TRlWnnV/GAtXy7DfEI=";
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
