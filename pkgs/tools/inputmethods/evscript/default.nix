{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "evscript";
  version = "git-${builtins.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "myfreeweb";
    repo = pname;
    rev = "410603abf4810320bf79bde90cc85367b71a8b12";
    sha256 = "sha256-apq3kHipEX6zOTNwqpIQR46JqmeE7EKVSOGrNNSkyu8=";
  };

  cargoHash = "sha256-5PWyxUfE6lkQ8CYXxq2/xp8hr5k73ZpK2RVJCgaWX1c=";

  meta = with lib; {
    homepage = "https://github.com/myfreeweb/${pname}";
    description = "A tiny sandboxed Dyon scripting environment for evdev input devices";
    license = licenses.unlicense;
    maintainers = with maintainers; [ milesbreslin ];
    platforms = platforms.linux;
  };
}
