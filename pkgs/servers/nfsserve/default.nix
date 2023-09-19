{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "nfsserve";
  version = "25d9f98522ddf263d16c7163c9fd17fd2278947c";

  src = fetchFromGitHub {
    owner = "xetdata";
    repo = pname;
    rev = version;
    hash = "sha256-1ObHpV3mijdsImdAsht8fDr7yZLKEucRT2fbek6lXW0=";
  };

  cargoHash = "sha256-nIIylSeUKIlUmgQeaeK/4MXqMA7xtSb5jKDvndO0Kq8=";

  # Cargo.lock is explicitly gitignored upstream.
  cargoPatches = [
    ./Cargo.lock.patch
  ];

  meta = with lib; {
    description = "Rust implementation of an NFSv3 server";
    homepage = "https://github.com/xetdata/nfsserve";
    license = licenses.bsd3;
    maintainers = [ maintainers.gmemstr ];
  };
}
