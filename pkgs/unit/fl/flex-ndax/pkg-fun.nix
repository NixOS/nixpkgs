{ stdenv, lib, buildGoModule, fetchFromGitHub, libpulseaudio }:

buildGoModule rec {
  pname = "flex-ndax";
  version = "0.2-20221007.1";

  src = fetchFromGitHub {
    owner = "kc2g-flex-tools";
    repo = "nDAX";
    rev = "v${version}";
    hash = "sha256-QldbiJnCjWrlXEPvyAqV5Xwz9YvsnVobVy/E/OB0A1k=";
  };

  buildInputs = [ libpulseaudio ];

  vendorSha256 = "sha256-eHy8oFYicVONQr31LQQ9b5auzeBoIzbszw2buKaBQbQ=";

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/kc2g-flex-tools/nDAX";
    description = "FlexRadio digital audio transport (DAX) connector for PulseAudio";
    license = licenses.mit;
    maintainers = with maintainers; [ mvs ];
  };
}
