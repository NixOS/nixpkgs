{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin, wireguard-go }:

rustPlatform.buildRustPackage rec {
  pname = "wg-netmanager";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "gin66";
    repo = "wg_netmanager";
    rev = "wg_netmanager-v${version}";
    sha256 = "1fbrgn1hnygfy337r52dhrq8h2lzdr0b675ys738ibiwwm6s558z";
  };

  # related to the Cargo.lock file
  cargoSha256 = "0wj6rlj5iyzgx5xxzd4mmza2kiwfnpyi918w7gb03hqppzd2xkrr";

  buildInputs = lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  # Test 01 tries to create a wireguard interface, which requires sudo.
  doCheck = false;
  checkFlags = "--test 02_";

  passthru.tests = {
  };

  meta = with lib; {
    description = "Wireguard network manager";
    longDescription = "Wireguard network manager, written in rust, simplifies the setup of wireguard nodes, identifies short connections between nodes residing in the same subnet, identifies unreachable aka dead nodes and maintains the routes between all nodes automatically. To achieve this, wireguard network manager needs to be running on each node.";
    homepage = "https://github.com/gin66/wg_netmanager";
    license = [ licenses.mit licenses.asl20 licenses.bsd3 licenses.mpl20 ];
    maintainers = with maintainers; [ gin66 ];
    platforms = platforms.linux;
  };
}
