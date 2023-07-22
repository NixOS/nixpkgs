{ lib
, stdenvNoCC
, fetchFromSourcehut
, shellcheck
, shellspec
, gnupg
, pass
, shfmt
, scdoc
, dmenu
, libnotify
, xdotool
}:

stdenvNoCC.mkDerivation rec {
  pname = "pass-sxatm";
  version = "0.1.0";
  src = fetchFromSourcehut {
    owner = "~onemoresuza";
    repo = pname;
    rev = version;
    domain = "sr.ht";
    vc = "git";
    hash = "sha256-+3jbB4zvgsLJybfcYZAqpY4WEyqcG09ixWf3kX447u4=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  nativeCheckInputs = [
    shellcheck
    shellspec
    gnupg
    pass
  ];

  nativeBuildInputs = [
    shfmt
    scdoc
  ];

  patchPhase = with lib; ''
    sed -i \
      's#\(PASSWORD_STORE_SXATM_MENU:-\)"dmenu"#\1"${getExe dmenu}"#' \
      "sxatm.bash"

    sed -i \
      's#\(PASSWORD_STORE_SXATM_NOTIFIER:-\)"notify-send"#\1"${getExe libnotify}"#' \
      "sxatm.bash"

    sed -i \
      's#xdotool#${getBin xdotool}/bin/xdotool #g' \
      "sxatm.bash"
  '';

  doCheck = true;

  meta = with lib; {
    description = "A simple X autofill tool with menu for pass";
    homepage = "https://sr.ht/~onemoresuza/pass-sxatm/";
    downloadPage = "https://git.sr.ht/~onemoresuza/pass-sxatm/refs/${version}";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ onemoresuza ];
  };
}
