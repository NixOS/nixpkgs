{ stdenv, fetchFromGitHub, autoreconfHook, coreutils }:

stdenv.mkDerivation rec {
  version = "1.2";
  pname = "light";
  src = fetchFromGitHub {
    owner = "haikarainen";
    repo = "light";
    rev = "v${version}";
    sha256 = "1h286va0r1xgxlnxfaaarrj3qhxmjjsivfn3khwm0wq1mhkfihra";
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
    homepage = https://haikarainen.github.io/light/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ puffnfresh dtzWill ];
    platforms = stdenv.lib.platforms.linux;
  };
}
