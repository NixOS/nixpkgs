{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-cross";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "rust-embedded";
    repo = "cross";
    rev = "v${version}";
    sha256 = "1py5w4kf612x4qxi190ilsrx0zzwdzk9i47ppvqblska1s47qa2w";
  };

  cargoSha256 = "sha256-zk6cbN4iSHnyoeWupufVf2yQK6aq3S99uk9lqpjCw4c=";

  cargoPatches = [
    (fetchpatch {
      url = "https://github.com/rust-embedded/cross/commit/e86ad2e5a55218395df7eaaf91900e22b809083c.patch";
      sha256 = "1zrcj5fm3irmlrfkgb65kp2pjkry0rg5nn9pwsk9p0i6dpapjc7k";
    })
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "Zero setup cross compilation and cross testing";
    homepage = "https://github.com/rust-embedded/cross";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ otavio ];
    mainProgram = "cross";
  };
}
