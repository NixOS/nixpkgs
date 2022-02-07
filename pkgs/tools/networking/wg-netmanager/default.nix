{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin, wireguard-go, Security }:

rustPlatform.buildRustPackage rec {
  pname = "wg-netmanager";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "gin66";
    repo = "wg_netmanager";
    rev = "wg_netmanager-v${version}";
    sha256 = "AAtSSBz2zGLIEpcEMbe1mfYZikiaYEI+6KeSL5n54PE=";
  };

  cargoSha256 = "17k83QkQDq5uRCRADRLD2Q7pv7yES20lpms/N/UK+BM=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  # Test 01 tries to create a wireguard interface, which requires sudo.
  doCheck = true;
  checkFlags = "--skip device";

  meta = with lib; {
    description = "Wireguard network manager";
    longDescription = "Wireguard network manager, written in rust, simplifies the setup of wireguard nodes, identifies short connections between nodes residing in the same subnet, identifies unreachable aka dead nodes and maintains the routes between all nodes automatically. To achieve this, wireguard network manager needs to be running on each node.";
    homepage = "https://github.com/gin66/wg_netmanager";
    license = with licenses; [ mit asl20 bsd3 mpl20 ];
    maintainers = with maintainers; [ gin66 ];
    platforms = platforms.linux;
  };
}
