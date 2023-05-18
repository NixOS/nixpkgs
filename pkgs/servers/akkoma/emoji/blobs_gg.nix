{ lib, fetchzip }:

let
  rev = "e764ba00b9c34524e3ff3ffd19a44fa2a5c296a5";
in fetchzip {
  pname = "blobs.gg";
  version = "unstable-2019-07-24";

  url = "https://git.pleroma.social/pleroma/emoji-index/-/raw/${rev}/packs/blobs_gg.zip";
  hash = "sha256-dnOwW93xTyJKRnYgvPgsqZHNWod4y80aNhBSVKNk6do=";

  stripRoot = false;

  meta = with lib; {
    description = "Blob emoji from blobs.gg repacked as APNG";
    homepage = "https://blobs.gg";
    license = licenses.asl20;
    maintainers = with maintainers; [ mvs ];
  };
}
