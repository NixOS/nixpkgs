{ stdenv, lib, fetchFromGitHub, hidapi, installShellFiles }:
stdenv.mkDerivation (finalAttrs: {
  pname = "usbrelay";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "darrylb123";
    repo = "usbrelay";
    rev = finalAttrs.version;
    sha256 = "sha256-9jEiMmBEpqY4+nKh3H8N/JrLohp/7oPK3rPmRjp2gvc=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    hidapi
  ];

  makeFlags = [
    "DIR_VERSION=${finalAttrs.version}"
    "PREFIX=${placeholder "out"}"
    "LDCONFIG=${stdenv.cc.libc.bin}/bin/ldconfig"
  ];

  postInstall = ''
    installManPage usbrelay.1
  '';

  meta = with lib; {
    description = "Tool to control USB HID relays";
    mainProgram = "usbrelay";
    homepage = "https://github.com/darrylb123/usbrelay";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wentasah ];
    platforms = platforms.linux;
  };
})
