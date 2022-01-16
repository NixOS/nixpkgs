{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "wg-netmanager";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "gin66";
    repo = "wg_netmanager";
    rev = "wg_netmanager-v${version}";
    sha256 = "0r0c7jv06rmm8qaxiax93nq0z1lpmsblg1b3nfyxmv4fwxc00xsn";
  };

  # related to the Cargo.lock file
  cargoSha256 = "0n258nycmpyb7ysrgsf0rx7mgpqjnjd3wf64dgrj12s4zphmy4as";

  buildInputs = lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  # Test 01 tries to create a wireguard interface, which requires sudo.
  doCheck = false;
  checkFlags = "--test 02_";

  meta = with lib; {
    description = "Wireguard network manager";
    longDescription = "Wireguard network manager, written in rust, simplifies the setup of wireguard nodes, identifies short connections between nodes residing in the same subnet, identifies unreachable aka dead nodes and maintains the routes between all nodes automatically. To achieve this, wireguard network manager needs to be running on each node.";
    homepage = "https://github.com/gin66/wg_netmanager";
    license = licenses.mit;
    maintainers = with maintainers; [ gin66 ];
    platforms = platforms.linux;
  };
}
