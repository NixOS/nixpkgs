{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goatcounter";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "arp242";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-SFfHjBpVc1x0USl/zBmMpm/3tlzGjvVSpTww6jQCTBM=";
  };

  vendorSha256 = "sha256-CnbDxvhs3qA6qbibezJ3H9fgPQh0GHbSHMcMF5OiXMg=";

  modRoot = ".";

  doCheck = false;

  meta = with lib; {
    description = "Easy web analytics. No tracking of personal data.";
    longDescription = ''
        GoatCounter is an open source web analytics platform available as a hosted
        service (free for non-commercial use) or self-hosted app. It aims to offer easy
        to use and meaningful privacy-friendly web analytics as an alternative to
        Google Analytics or Matomo.
    '';
    homepage = "https://github.com/arp242/goatcounter";
    license = licenses.eupl12;
    maintainers = with maintainers; [ hanemile ];
  };
}
