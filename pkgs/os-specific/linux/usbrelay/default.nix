{ stdenv, lib, fetchFromGitHub, hidapi }:
stdenv.mkDerivation rec {
  pname = "usbrelay";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "darrylb123";
    repo = "usbrelay";
    rev = version;
    sha256 = "sha256-bxME4r5W5bZKxMZ/Svi1EenqHKVWIjU6iiKaM8U6lmA=";
  };

  buildInputs = [
    hidapi
  ];

  makeFlags = [
    "DIR_VERSION=${version}"
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Tool to control USB HID relays";
    homepage = "https://github.com/darrylb123/usbrelay";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wentasah ];
    platforms = platforms.linux;
  };
}
