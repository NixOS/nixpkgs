{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "bandwhich";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "imsnif";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9+7ol2QSIXLkkRt/YlAobZHb3Tm+SmnjW/JufwimMTE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "packet-builder-0.7.0" = "sha256-KxNrnLZ/z3JJ3E1pCTJF9tNXI7XYNRc6ooTUz3avpjw=";
    };
  };

  checkFlags = [
    # failing in upstream CI
    "--skip=tests::cases::ui::layout_under_50_width_under_50_height"
  ];

  buildInputs = lib.optional stdenv.isDarwin Security;

  # 10 passed; 47 failed https://hydra.nixos.org/build/148943783/nixlog/1
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "A CLI utility for displaying current network utilization";
    longDescription = ''
      bandwhich sniffs a given network interface and records IP packet size, cross
      referencing it with the /proc filesystem on linux or lsof on MacOS. It is
      responsive to the terminal window size, displaying less info if there is
      no room for it. It will also attempt to resolve ips to their host name in
      the background using reverse DNS on a best effort basis.
    '';
    homepage = "https://github.com/imsnif/bandwhich";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne figsoda ];
    platforms = platforms.unix;
  };
}
