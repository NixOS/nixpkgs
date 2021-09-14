{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "natscli";
  version = "0.0.26";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = version;
    sha256 = "sha256-w0a2BzfRKf55hFgdaDLsR2YeC5Jqa2uynlRN2oGPX8g=";
  };

  vendorSha256 = "sha256-kt6KflivmsG6prxWXtODcXSP2sNn4daH8ruZMxYLk3g=";

  meta = with lib; {
    description = "NATS Command Line Interface";
    homepage = "https://github.com/nats-io/natscli";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
