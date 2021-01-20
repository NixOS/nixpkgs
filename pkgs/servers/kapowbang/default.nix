{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kapowbang";
  version = "0.6.0";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "BBVA";
    repo = "kapow";
    rev = "v${version}";
    sha256 = "sha256-+GZarnG+SlxynoXYTvI1f9eki3DobiDt7vUdWlC0ECk=";
  };

  vendorSha256 = "sha256-vXu64o/MTmw9oZL4MIHB+PEfYLcKVh5A5iGZ1RW1Xd4=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/BBVA/kapow";
    description = "Expose command-line tools over HTTP";
    license = licenses.asl20;
    maintainers = with maintainers; [ nilp0inter ];
  };
}
