{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, fetchpatch
, pkg-config
, btrfs-progs
, gpgme
, lvm2
}:

buildGoModule rec {
  pname = "dive";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "wagoodman";
    repo = "dive";
    rev = "v${version}";
    hash = "sha256-9REthyb+bzsb7NBXkU9XyUZJFQHHrV1cG4//lTLgTgw=";
  };

  patches = [
    # fixes: unsafe.Slice requires go1.17 or later (-lang was set to go1.16; check go.mod)
    # https://github.com/wagoodman/dive/pull/461
    (fetchpatch {
      url = "https://github.com/wagoodman/dive/commit/555555d777f961ad0a2d1bb843e87f434d731dba.patch";
      hash = "sha256-tPSgvENiVgrlQSkT7LbQPRYhkkaYQeWRJ0P4bA3XOiI=";
    })
  ];

  vendorHash = "sha256-6KIbTrkvdugsUKdFBqtPUFzs/6h2xslLFpr6S2nSBiY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ btrfs-progs gpgme lvm2 ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "A tool for exploring each layer in a docker image";
    homepage = "https://github.com/wagoodman/dive";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam SuperSandro2000 ];
  };
}
