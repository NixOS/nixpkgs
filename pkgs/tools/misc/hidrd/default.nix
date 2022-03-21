{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation {
  pname = "hidrd";
  version = "unstable-2019-06-03";

  src = fetchFromGitHub {
    owner = "DIGImend";
    repo = "hidrd";
    rev = "6c0ed39708a5777ac620f902f39c8a0e03eefe4e";
    sha256 = "1rnhq6b0nrmphdig1qrpzpbpqlg3943gzpw0v7p5rwcdynb6bb94";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "HID report descriptor I/O library and conversion tool";
    homepage = "https://github.com/DIGImend/hidrd";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pacien ];
    platforms = platforms.all;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/hidrd.x86_64-darwin
  };
}
