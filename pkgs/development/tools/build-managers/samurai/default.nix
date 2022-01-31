{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "samurai";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "michaelforney";
    repo = pname;
    rev = version;
    sha256 = "sha256-RPY3MFlnSDBZ5LOkdWnMiR/CZIBdqIFo9uLU+SAKPBI=";
  };

  makeFlags = [ "DESTDIR=" "PREFIX=${placeholder "out"}" ];

  patches = [
    (fetchpatch {
      name = "CVE-2021-30218.patch";
      url = "https://github.com/michaelforney/samurai/commit/e84b6d99c85043fa1ba54851ee500540ec206918.patch";
      sha256 = "sha256-hyndwj6st4rwOJ35Iu0qL12dR5E6CBvsulvR27PYKMw=";
    })
    (fetchpatch {
      name = "CVE-2021-30219.patch";
      url = "https://github.com/michaelforney/samurai/commit/d2af3bc375e2a77139c3a28d6128c60cd8d08655.patch";
      sha256 = "sha256-rcdwKjHeq5Oaga9wezdHSg/7ljkynfbnkBc2ciMW5so=";
    })
  ];

  meta = with lib; {
    description = "ninja-compatible build tool written in C";
    homepage = "https://github.com/michaelforney/samurai";
    license = with licenses; [ mit asl20 ]; # see LICENSE
    maintainers = with maintainers; [ dtzWill ];
  };
}

