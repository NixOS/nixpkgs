{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin, wireguard-go }:

rustPlatform.buildRustPackage rec {
  pname = "wg-netmanager";
  version = "0.3.13";

  src = fetchFromGitHub {
    owner = "gin66";
    repo = "wg_netmanager";
    rev = "wg_netmanager-v${version}";
    sha256 = "x+94GSA4HXwpwlpqT+nYGOlS1lhW6Q9NRgmfj3pUjrs=";
  };

  # related to the Cargo.lock file
  cargoSha256 = "I0Mz2nh9letGdTcWWsSfXHY/4y0zmLvZwLvUopOf5Sk=";

  buildInputs = lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  # Test 01 tries to create a wireguard interface, which requires sudo.
  doCheck = true;
  checkFlags = "--skip device";

  passthru.tests = {
  };

  meta = with lib; {
    description = "Wireguard network manager";
    longDescription = "Wireguard network manager, written in rust, simplifies the setup of wireguard nodes, identifies short connections between nodes residing in the same subnet, identifies unreachable aka dead nodes and maintains the routes between all nodes automatically. To achieve this, wireguard network manager needs to be running on each node.";
    homepage = "https://github.com/gin66/wg_netmanager";
    license = with licenses; [ mit asl20 bsd3 mpl20 ];
    maintainers = with maintainers; [ gin66 ];
    platforms = platforms.linux;
  };
}
