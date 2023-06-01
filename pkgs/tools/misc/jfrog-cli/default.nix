{ lib
, buildGoModule
, fetchFromGitHub
, pkgs
}:

buildGoModule rec {
  pname = "jfrog-cli";
  version = "2.38.2";

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-oCcpW4JP61w7TIWR11g/NaHri93cgGorEmRndZXZyE0=";
  };

  vendorHash = "sha256-voMKA7NpQHF4DIZP+vO/ZwlOcBNFwp3vThCM7s8RSpY=";

  postInstall = ''
    # Name the output the same way as the original build script does
    mv $out/bin/jfrog-cli $out/bin/jf
  '';

  # Some of the tests require a writable $HOME
  preCheck = "export HOME=$TMPDIR";

  meta = with lib; {
    homepage = "https://github.com/jfrog/jfrog-cli";
    description = "Client for accessing to JFrog's Artifactory and Mission Control through their respective REST APIs";
    changelog = "https://github.com/jfrog/jfrog-cli/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "jf";
    maintainers = with maintainers; [ detegr ];
  };
}
