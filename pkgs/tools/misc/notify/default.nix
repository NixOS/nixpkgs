{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "notify";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PZSt4mhon0JbFxeq5tOXb+xWKOoxT6rjRS1E3Jf2V3c=";
  };

  vendorSha256 = "sha256-MoGaIs2WmJk+E8pTljrahuaJ1VwYBhGBf1XGYVYOVt4=";

  modRoot = ".";
  subPackages = [
    "cmd/notify/"
  ];

  # Test files are not part of the release tarball
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
  };

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
