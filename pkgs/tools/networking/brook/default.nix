{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "brook";
  version = "20220406";

  src = fetchFromGitHub {
    owner = "txthinking";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KCDXi86Wi01wEIJXPYYX5HkQMq7nKK2VhsN1x5yOvlk=";
  };

  vendorSha256 = "sha256-ic5QYRVElEuH4D29PXgTzMHU0KjrxDqcdfg7Kd37/YU=";

  meta = with lib; {
    homepage = "https://github.com/txthinking/brook";
    description = "A cross-platform Proxy/VPN software";
    license = with licenses; [ gpl3Only ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ xrelkd ];
  };
}
