{ lib, stdenv, fetchFromGitHub, rustPlatform, Security, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "bandwhich";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "imsnif";
    repo = pname;
    rev = version;
    hash = "sha256-lggeJrPfZTpUEydFJ9XXgbbS3pmrGqTef2ROsPOmiwQ=";
  };

  cargoHash = "sha256-kGRsF+THNQahEoD3vY+XcPrr9cHjchtg86tMvcIdHPk=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  # 10 passed; 47 failed https://hydra.nixos.org/build/148943783/nixlog/1
  doCheck = !stdenv.isDarwin;

  cargoPatches = [
    # FIXME: remove when the linked-hash-map dependency is bumped upstream
    # https://github.com/imsnif/bandwhich/pull/222/
    (fetchpatch {
      name = "update-linked-hash-map.patch";
      url = "https://github.com/imsnif/bandwhich/commit/be06905de2c4fb91afc22d50bf3cfe5a1e8003f5.patch";
      hash = "sha256-FyZ7jUXK7ebXq7q/lvRSe7YdPnpYWKZE3WrSKLMjJeA=";
    })

    # Tweaked https://github.com/imsnif/bandwhich/pull/245 so that it merges
    # cleanly with the earlier patch.
    ./update-socket2-for-rust-1.64.diff
  ];

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
    maintainers = with maintainers; [ Br1ght0ne SuperSandro2000 ];
    platforms = platforms.unix;
  };
}
