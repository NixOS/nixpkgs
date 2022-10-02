{ stdenv, lib, fetchFromGitHub, hidapi, installShellFiles }:
stdenv.mkDerivation rec {
  pname = "usbrelay";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "darrylb123";
    repo = "usbrelay";
    rev = version;
    sha256 = "sha256-2elDrO+WaaRYdTrG40Ez00qSsNVQjXE6GdOJbWPfugE=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    hidapi
  ];

  makeFlags = [
    "DIR_VERSION=${version}"
    "PREFIX=${placeholder "out"}"
  ];

  postInstall = ''
    installManPage usbrelay.1
  '';

  meta = with lib; {
    description = "Tool to control USB HID relays";
    homepage = "https://github.com/darrylb123/usbrelay";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wentasah ];
    platforms = platforms.linux;
  };
}
