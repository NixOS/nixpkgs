{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "as-tree";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "jez";
    repo = pname;
    rev = version;
    sha256 = "0c0g32pkyhyvqpgvzlw9244c80npq6s8mxy3may7q4qyd7hi3dz5";
  };

  cargoSha256 = "1m334shcja7kg134b7lnq1ksy67j5b5vblkzamrw06f6r1hkn1rc";
  # the upstream 0.12.0 release didn't update the Cargo.lock file properly
  # they have updated their release script, so this patch can be removed
  # when the next version is released.
  cargoPatches = [ ./cargo-lock.patch ];

  meta = with lib; {
    description = "Print a list of paths as a tree of paths";
    homepage = "https://github.com/jez/as-tree";
    license = with licenses; [ blueOak100 ];
    maintainers = with maintainers; [ jshholland ];
    platforms = platforms.all;
  };
}
