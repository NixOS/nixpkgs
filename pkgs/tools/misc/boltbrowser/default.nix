{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "boltbrowser";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "br0xen";
    repo = pname;
    rev = version;
    sha256 = "17v3pv80dxs285d0b6x772h5cb4f0xg9n5p9jwlir5hjbfn1635i";
  };

  vendorSha256 = "1x28m72626cchnsasyxips8jaqs0l2p9jhjrdcgws144zm6fz3hv";

  meta = with lib; {
    description = "CLI Browser for BoltDB files";
    homepage = "https://github.com/br0xen/boltbrowser";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
