{ lib, rustPlatform, fetchCrate }:
rustPlatform.buildRustPackage rec {
  pname = "puppy";
  version = "0.0.7";
  src = fetchCrate {
    inherit version;
    crateName = pname;
    sha256 = "0zxksg3ywnddm5i7ipcp2v103j64yrh3vd0z9isxv9caa6adlb1b";
  };
  cargoSha256 = "1qr6ng9hh2jz5qmqcp2l002djq9kqxxr42wsl827pj3vpgx3bp92";

  meta = with lib; {
    description = "A fortune(1)-like program that outputs puppy tweets";
    homepage = "https://github.com/eiais/puppy.rs";
    license = licenses.mit;
    maintainers = [ maintainers.rebecca ];
    platforms = platforms.all;
  };
}
