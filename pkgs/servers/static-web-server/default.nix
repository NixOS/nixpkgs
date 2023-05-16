<<<<<<< HEAD
{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin, nixosTests }:

rustPlatform.buildRustPackage rec {
  pname = "static-web-server";
  version = "2.21.1";
=======
{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "static-web-server";
  version = "2.16.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "static-web-server";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-odt9ztEjb+ppi1e+SI7T6BGtSWVG4EM14lyuVoz5gOM=";
  };

  cargoHash = "sha256-HWiMaMnco4xkskjRroqgy11D/Plg/1VDZwn/IpNG6LM=";
=======
    sha256 = "sha256-ZHJGUgFCguUszcpzXwAK1XH3Ds4b87pyiohabvIwMX4=";
  };

  cargoHash = "sha256-7JOJknBJuX0anzd6Oqp3HEzYtEQfRkcHdjNBzW59P+E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # TODO: investigate why these tests fail
    "--skip=tests::handle_byte_ranges_if_range_too_old"
    "--skip=tests::handle_not_modified"
    "--skip=handle_precondition"
  ];

<<<<<<< HEAD
  # Need to copy in the systemd units for systemd.packages to discover them
  postInstall = ''
    install -Dm444 -t $out/lib/systemd/system/ systemd/static-web-server.{service,socket}
  '';

  passthru.tests = { inherit (nixosTests) static-web-server; };

  meta = with lib; {
    description = "An asynchronous web server for static files-serving";
=======
  meta = with lib; {
    description = "An asynchronus web server for static files-serving";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://static-web-server.net/";
    changelog = "https://github.com/static-web-server/static-web-server/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
