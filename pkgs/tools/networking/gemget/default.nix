{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gemget";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "makeworld-the-better-one";
    repo = pname;
    rev = "v${version}";
    sha256 = "PmtIgxnzfLduNGTx8SNDky6juv+NTJ8Cr++SOCk/QNU=";
  };

  vendorSha256 = "sha256-Ep6HAJgurxFbA4L77z8V2ar06BBVWlAJS9VoSSUg27U=";

  meta = with lib; {
    description = "Command line downloader for the Gemini protocol";
    homepage = "https://github.com/makeworld-the-better-one/gemget";
    license = licenses.mit;
    maintainers = with maintainers; [ amfl ];
  };
}
