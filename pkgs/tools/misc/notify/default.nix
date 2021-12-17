{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "notify";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-grTHSMN4PpsCo5mST6nXE5+u7DewMVJXI3hnNIJdhLs=";
  };

  vendorSha256 = "sha256-BbhDNy3FmnHzAfv3lxPwL2jhp8Opfo0WVFhncfTO/28=";

  modRoot = ".";
  subPackages = [
    "cmd/notify/"
  ];

  # Test files are not part of the release tarball
  doCheck = false;

  meta = with lib; {
    description = "Notify allows sending the output from any tool to Slack, Discord and Telegram";
    longDescription = ''
      Notify is a helper utility written in Go that allows you to post the output from any tool
      to Slack, Discord, and Telegram.
    '';
    homepage = "https://github.com/projectdiscovery/notify";
    license = licenses.mit;
    maintainers = with maintainers; [ hanemile ];
  };
}
