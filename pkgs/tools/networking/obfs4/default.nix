{ lib, fetchgit, buildGoModule }:

buildGoModule rec {
  pname = "obfs4";
  version = "0.0.10";

  src = fetchgit {
    url = meta.repositories.git;
    rev = "refs/tags/${pname}proxy-${version}";
    sha256 = "05aqmw8x8s0yqyqmdj5zcsq06gsbcmrlcd52gaqm20m1pg9503ad";
  };

  modSha256 = "150kg22kznrdj5icjxk3qd70g7wpq8zd2zklw1y2fgvrggw8zvyv";

  meta = with lib; {
    description = "A pluggable transport proxy";
    homepage = https://www.torproject.org/projects/obfsproxy;
    repositories.git = https://git.torproject.org/pluggable-transports/obfs4.git;
    maintainers = with maintainers; [ phreedom thoughtpolice ];
  };
}
