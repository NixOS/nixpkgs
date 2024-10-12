{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, gettext
}:

stdenv.mkDerivation rec {
  pname = "mac-telnet";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "haakonnessjoen";
    repo = "MAC-Telnet";
    rev = "v${version}";
    hash = "sha256-ZBJ3GTTXV14DMcKZWkhNDfOzsL+cCahBzTtnJsRvw/w=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    gettext
  ];

  patchPhase = ''
    runHook prePatch

    # Remove unnecessary chmodding from Makefile
    head -1 config/Makefile.am > config/Makefile.am

    runHook postPatch
  '';

  fixupPhase = ''
    runHook preFixup

    rm -rf $out/sbin

    runHook postFixup
  '';

  meta = with lib; {
    description = "Open source MAC Telnet client and server for connecting to Microtik RouterOS routers and Posix machines via MAC address";
    homepage = "https://github.com/haakonnessjoen/MAC-Telnet";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
