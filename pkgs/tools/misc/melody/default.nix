{ lib, stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "melody";
  version = "0.13.10";

  src = fetchCrate {
    pname = "melody_cli";
    inherit version;
    sha256 = "05slrh5dqbpsvimdr0rlhj04kf1qzwij3zlardvbmvhvfccf4188";
  };

  cargoSha256 = "0qh1byysbc6pl3cvx2vdpl8crx5id59hhrwqzk5g7091spm8wf79";

  meta = with lib; {
    description = "Language that compiles to regular expressions";
    homepage = "https://github.com/yoav-lavi/melody";
    license = licenses.mit;
    maintainers = with maintainers; [ jyooru ];
  };
}
