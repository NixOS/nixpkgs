{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "meek";
  version = "0.37.0";
  src = fetchgit {
    url = "https://git.torproject.org/pluggable-transports/meek.git";
    rev = "v${version}";
    hash = "sha256-bH7zrrHaVD7WplpEte1KfjzX0FMwp8MsHaOXe4Xlz3Q=";
  };

  vendorSha256 = "uFHqiYOKNVUXeNjVnVjjDQm2sLBh81Q2yWgQjusb9Ys=";

  meta = with lib; {
    maintainers = with maintainers; [ lourkeur ];
    license = licenses.cc0;
  };
}
