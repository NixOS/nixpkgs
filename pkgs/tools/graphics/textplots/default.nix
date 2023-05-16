<<<<<<< HEAD
{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "textplots";
  version = "0.8.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-DtDxD3b8idYOBcHKkLbOy6NUU0bjWzDySGoW8uOT4xc=";
  };

  cargoHash = "sha256-tXqonC4qawS6eu9dPt/6/TVYCjTroG+9XikmYQHCLdA=";

  buildFeatures = [ "tool" ];
=======
{ fetchCrate, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "textplots";
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "07lxnvg8g24r1j6h07w91j5lp0azngmb76lagk55y28br0y70qr4";
  };

  cargoSha256 = "19xb1ann3bqx26nhjjvcwqdsvzg7lflg9fdrnlx05ndd2ip44flz";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Terminal plotting written in Rust";
    homepage = "https://github.com/loony-bean/textplots-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
