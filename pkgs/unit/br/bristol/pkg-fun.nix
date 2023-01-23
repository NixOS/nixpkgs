{ lib, stdenv, fetchurl, alsa-lib, libjack2, pkg-config, libpulseaudio, xorg }:

stdenv.mkDerivation  rec {
  pname = "bristol";
  version = "0.60.11";

  src = fetchurl {
    url = "mirror://sourceforge/bristol/${pname}-${version}.tar.gz";
    sha256 = "1fi2m4gmvxdi260821y09lxsimq82yv4k5bbgk3kyc3x1nyhn7vx";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    alsa-lib libjack2 libpulseaudio xorg.libX11 xorg.libXext
    xorg.xorgproto
  ];

  patchPhase = "sed -i '41,43d' libbristolaudio/audioEngineJack.c"; # disable alsa/iatomic

  configurePhase = "./configure --prefix=$out --enable-jack-default-audio --enable-jack-default-midi";

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #  ld: brightonCLI.o:/build/bristol-0.60.11/brighton/brightonCLI.c:139: multiple definition of
  #    `event'; brightonMixerMenu.o:/build/bristol-0.60.11/brighton/brightonMixerMenu.c:1182: first defined here
  NIX_CFLAGS_COMPILE = "-fcommon";

  preInstall = ''
    sed -e "s@\`which bristol\`@$out/bin/bristol@g" -i bin/startBristol
    sed -e "s@\`which brighton\`@$out/bin/brighton@g" -i bin/startBristol
  '';

  meta = with lib; {
    description = "A range of synthesiser, electric piano and organ emulations";
    homepage = "http://bristol.sourceforge.net";
    license = licenses.gpl3;
    platforms = ["x86_64-linux" "i686-linux"];
    maintainers = [ maintainers.goibhniu ];
  };
}
