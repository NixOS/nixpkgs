{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  coreutils,
}:

stdenv.mkDerivation rec {
  version = "1.2.2";
  pname = "light";
  src = fetchFromGitHub {
    owner = "haikarainen";
    repo = "light";
    rev = "v${version}";
    sha256 = "1a70zcf88ifsnwll486aicjnh48zisdf8f7vi34ihw61kdadsq9s";
  };

  patches = [
    # Pull upstream fix for -fno-common toolchains:
    #  https://github.com/haikarainen/light/pull/135
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/haikarainen/light/commit/eae912ca7ff3356805e47739114861d2b6ae7ec0.patch";
      sha256 = "15jp8hm5scl0myiy1jmvd6m52lhx5jscvi3rgb5siwakmnkgzx9j";
    })
  ];

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
    mainProgram = "light";
    maintainers = with lib.maintainers; [
      puffnfresh
      dtzWill
    ];
    platforms = lib.platforms.linux;
  };
}
