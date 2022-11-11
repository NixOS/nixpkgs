{ lib
, fetchurl
, buildGoModule }:

buildGoModule rec {
  pname = "obfs4";
  version = "0.0.14-tor2";

  src = fetchurl {
    url = "https://gitweb.torproject.org/pluggable-transports/obfs4.git/snapshot/obfs4proxy-${version}.tar.gz";
    hash = "sha256-S/gVj8Lf8ypvgT4DwDL+v0J7NbefBzRdn9zno4+wp0I=";
  };

  vendorSha256 = "sha256-6YnpjgilY4rlMm+Yv6JzLUAN1IUAgN0uYiNKvZwBLqw=";

  meta = with lib; {
    description = "A pluggable transport proxy";
    homepage = "https://www.torproject.org/projects/obfsproxy";
    maintainers = with maintainers; [ thoughtpolice ];
    mainProgram = "obfs4proxy";
  };
}
