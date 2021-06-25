{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "evscript";
  version = "git-${builtins.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "myfreeweb";
    repo = pname;
    rev = "47f86f0d15add2af785ea1ff47f24d130026d1b4";
    sha256 = "1xm8297k0d8d0aq7fxgmibr4qva4d02cb6gnnlzq77jcmnknxv14";
  };

  cargoSha256 = "1z0xxbjnhhzn1fnc3zhvy727l88qyyfqdayj5yvf3nh23m7sr87l";

  meta = with lib; {
    homepage = "https://github.com/myfreeweb/${pname}";
    description = "A tiny sandboxed Dyon scripting environment for evdev input devices";
    license = licenses.unlicense;
    maintainers = with maintainers; [ milesbreslin ];
    platforms = platforms.linux;
  };
}
