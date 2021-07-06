{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "notify";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "1nlsl4himxs5jv0fcd48jkwjnmn1w3alp0dcm1awmp6702zrsgqj";
  };

  vendorSha256 = "13dz0sk3561hrixsl1ghr9y0pzap2a8zrlbzzb7zs7550snbdcyg";

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
