{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "brook";
  version = "20220707";

  src = fetchFromGitHub {
    owner = "txthinking";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TlbVXfNUvCHHX0BReSVE6GNfmS+p6lWSdO0OtOC+I2U=";
  };

  vendorSha256 = "sha256-MPLM1lBM1K55q6nsfmOekdFlSDmPsLLDv09mD1XqLNo=";

  meta = with lib; {
    homepage = "https://github.com/txthinking/brook";
    description = "A cross-platform Proxy/VPN software";
    license = with licenses; [ gpl3Only ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ xrelkd ];
  };
}
