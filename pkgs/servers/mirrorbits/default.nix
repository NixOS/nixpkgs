{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
, pkg-config
, zlib
, geoip
}:

buildGoModule rec {
  pname = "mirrorbits";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "etix";
    repo = "mirrorbits";
    rev = "v${version}";
    hash = "sha256-Ta3+Y3P74cvx09Z4rB5ObgBZtfF4grVgyeZ57yFPlGM=";
  };

  vendorHash = null;

  patches = [
    # Add Go Modules support
    (fetchpatch {
      url = "https://github.com/etix/mirrorbits/commit/955a8b2e1aacea1cae06396a64afbb531ceb36d4.patch";
      hash = "sha256-KJgj3ynnjjiXG5qsUmzBiMjGEwfvM/9Ap+ZgUdhclik=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zlib geoip ];

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "geographical download redirector for distributing files efficiently across a set of mirrors";
    homepage = "https://github.com/etix/mirrorbits";
    longDescription = ''
      Mirrorbits is a geographical download redirector written in Go for
      distributing files efficiently across a set of mirrors. It offers
      a simple and economic way to create a Content Delivery Network
      layer using a pure software stack. It is primarily designed for
      the distribution of large-scale Open-Source projects with a lot
      of traffic.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.unix;
  };
}
