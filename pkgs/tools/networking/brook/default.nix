{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "brook";
  version = "20221010";

  src = fetchFromGitHub {
    owner = "txthinking";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-l5sdujUj6uHL7uuntAxagROvzOc/Z648ax6ZADtA/bk=";
  };

  vendorSha256 = "sha256-kNd0TYaJmz7+bOXf7EaDsiU14eJmz9BPdhKmR7HhxCo=";

  meta = with lib; {
    homepage = "https://github.com/txthinking/brook";
    description = "A cross-platform Proxy/VPN software";
    license = with licenses; [ gpl3Only ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ xrelkd ];
  };
}
