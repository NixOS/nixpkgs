{ stdenv, fetchFromGitHub }:

let
  pname = "platformio-udev-rules";
  version = "4.3.4";
in stdenv.mkDerivation {
  inherit version pname;

  src = fetchFromGitHub {
    owner = "platformio";
    repo = "platformio-core";
    rev = "v${version}";
    sha256 = "0vf2j79319ypr4yrdmx84853igkb188sjfvlxgw06rlsvsm3kacq";
  };

  installPhase = ''
    mkdir -p $out/lib/udev/rules.d
    install -D scripts/99-platformio-udev.rules $out/lib/udev/rules.d/99-platformio.rules
  '';

  dontBuild = true;
  dontConfigure = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/platformio/platformio-core";
    description = "Udev rules for PlatformIO";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = with maintainers; [ f4814n ];
  };
}
