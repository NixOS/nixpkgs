{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "src-cli";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "src-cli";
    rev = "${version}";
    sha256 = "sha256-sCZDe5p71WQN/tIt/DcTXWOiYso4fvh+U3jXkguOGrQ=";
  };

  vendorSha256 = "sha256-7JgcT1cGDtYGoT6QLPZ4fk40AzT3uv15VXk+Fgcl2S8=";

  doCheck = false;

  meta = with lib; {
    description = "Command line interface to Sourcegraph";
    homepage = "https://github.com/sourcegraph/src-cli";
    changelog = "https://github.com/sourcegraph/src-cli/blob/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ loicreynier ];
    license = licenses.asl20;
  };
}
