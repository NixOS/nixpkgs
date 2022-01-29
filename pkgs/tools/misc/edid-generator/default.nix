{ lib, stdenv
, fetchFromGitHub
, dos2unix
, edid-decode
, hexdump
, zsh
, modelines ? [] # Modeline "1280x800"   83.50  1280 1352 1480 1680  800 803 809 831 -hsync +vsync
}:

stdenv.mkDerivation rec {
  pname = "edid-generator";
  version = "unstable-2018-03-15";

  src = fetchFromGitHub {
    owner = "akatrevorjay";
    repo = "edid-generator";
    rev = "31a6f80784d289d2faa8c4ca4788409c83b3ea14";
    sha256 = "0j6wqzx5frca8b5i6812vvr5iwk7440fka70bmqn00k0vfhsc2x3";
  };

  nativeBuildInputs = [ dos2unix edid-decode hexdump zsh ];

  postPatch = ''
    patchShebangs modeline2edid
  '';

  configurePhase = (lib.concatMapStringsSep "\n" (m: "echo \"${m}\" | ./modeline2edid -") modelines);

  installPhase = ''
    install -Dm 444 *.bin -t "$out/lib/firmware/edid"
  '';

  meta = {
    description = "Hackerswork to generate an EDID blob from given Xorg Modelines";
    homepage = "https://github.com/akatrevorjay/edid-generator";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.flokli ];
    platforms = lib.platforms.all;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/edid-generator.x86_64-darwin
  };
}
