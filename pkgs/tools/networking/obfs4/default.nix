{ lib, fetchgit, buildGoModule }:

buildGoModule rec {
  pname = "obfs4";
  version = "0.0.10";

  src = fetchgit {
    url = meta.repositories.git;
    rev = "refs/tags/${pname}proxy-${version}";
    sha256 = "05aqmw8x8s0yqyqmdj5zcsq06gsbcmrlcd52gaqm20m1pg9503ad";
  };

  vendorSha256 = "0h3gjxv26pc6cysvy1hny2f4abw6i847dk8fx0m113ixx9qghk87";

  meta = with lib; {
    description = "A pluggable transport proxy";
    homepage = "https://www.torproject.org/projects/obfsproxy";
    repositories.git = "https://git.torproject.org/pluggable-transports/obfs4.git";
    maintainers = with maintainers; [ phreedom thoughtpolice ];
  };
}
