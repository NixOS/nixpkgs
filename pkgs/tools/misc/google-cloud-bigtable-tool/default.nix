{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "google-cloud-bigtable-tool";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "cloud-bigtable-cbt-cli";
    rev = "v.${version}";
    hash = "sha256-N5nbWMj7kLIdRiwBUWFz4Rat88Wx01i3hceMxAvSjaA=";
  };

  vendorHash = "sha256-kwvEfvHs6XF84bB3Ss1307OjId0nh/0Imih1fRFdY0M=";

  preCheck = ''
    buildFlagsArray+="-short"
  '';

  meta = with lib; {
    description = "Google Cloud Bigtable Tool";
    longDescription = ''
      `cbt` is the Google Cloud Bigtable Tool. A CLI utility to interact with Google Cloud Bigtable.
      The cbt CLI is a command-line interface for performing several different operations on Cloud Bigtable.
      It is written in Go using the Go client library for Cloud Bigtable.
      An overview of its usage can be found in the [Google Cloud docs](https://cloud.google.com/bigtable/docs/cbt-overview).
      For information about Bigtable in general, see the [overview of Bigtable](https://cloud.google.com/bigtable/docs/overview).
    '';
    homepage = "https://github.com/googleapis/cloud-bigtable-cbt-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ totoroot ];
    mainProgram = "cbt";
  };
}
