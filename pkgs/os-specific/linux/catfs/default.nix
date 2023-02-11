{ lib, rustPlatform, fetchFromGitHub
, fetchpatch
, fuse
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "catfs";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "kahing";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OvmtU2jpewP5EqPwEFAf67t8UCI1WuzUO2QQj4cH1Ak=";
  };

  patches = [
    # monitor https://github.com/kahing/catfs/issues/71
    ./fix-for-rust-1.65.diff
  ];

  cargoHash = "sha256-xF1J2Pr4qtNFcd2kec4tnbdYxoLK+jRnzp8p+cmNOcI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ fuse ];

  # require fuse module to be active to run tests
  # instead, run command
  doCheck = false;
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/catfs --help > /dev/null
  '';

  meta = with lib; {
    description = "Caching filesystem written in Rust";
    homepage = "https://github.com/kahing/catfs";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jonringer ];
  };
}
