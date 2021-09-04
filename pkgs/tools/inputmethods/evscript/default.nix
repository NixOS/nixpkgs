{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "evscript";
  version = "git-2021-06-16";

  src = fetchFromGitHub {
    owner = "myfreeweb";
    repo = pname;
    rev = "410603abf4810320bf79bde90cc85367b71a8b12";
    sha256 = "sha256-apq3kHipEX6zOTNwqpIQR46JqmeE7EKVSOGrNNSkyu8=";
  };

  cargoHash = "sha256-h1Znx69mFIXCs0x3AtFT2brSbdfMJGB0Ht7v4HDfEqM=";

  meta = with lib; {
    homepage = "https://github.com/myfreeweb/evscript";
    description = "A tiny sandboxed Dyon scripting environment for evdev input devices";
    license = licenses.unlicense;
    maintainers = with maintainers; [ milesbreslin ];
    platforms = platforms.linux;
  };
}
