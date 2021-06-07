{ lib, stdenv, fetchFromGitHub, autoreconfHook, coreutils }:

stdenv.mkDerivation rec {
  version = "1.2.2";
  pname = "light";
  src = fetchFromGitHub {
    owner = "haikarainen";
    repo = "light";
    rev = "v${version}";
    sha256 = "1a70zcf88ifsnwll486aicjnh48zisdf8f7vi34ihw61kdadsq9s";
  };

  configureFlags = [ "--with-udev" ];

  nativeBuildInputs = [ autoreconfHook ];

  # ensure udev rules can find the commands used
  postPatch = ''
    substituteInPlace 90-backlight.rules \
      --replace '/bin/chgrp' '${coreutils}/bin/chgrp' \
      --replace '/bin/chmod' '${coreutils}/bin/chmod'
  '';

  meta = {
    description = "GNU/Linux application to control backlights";
    homepage = "https://haikarainen.github.io/light/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ puffnfresh dtzWill ];
    platforms = lib.platforms.linux;
  };
}
