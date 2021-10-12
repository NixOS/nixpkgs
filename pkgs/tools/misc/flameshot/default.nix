{ mkDerivation
, lib
, fetchFromGitHub
, qtbase
, cmake
, qttools
, qtsvg
, nix-update-script
}:

mkDerivation rec {
  pname = "flameshot";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "flameshot-org";
    repo = "flameshot";
    rev = "v${version}";
    sha256 = "1ncknjayl6am740f49g0lc28z1zsifbicxz1j1kwps3ksj15nl7a";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  nativeBuildInputs = [ cmake qttools qtsvg ];
  buildInputs = [ qtbase ];

  meta = with lib; {
    description = "Powerful yet simple to use screenshot software";
    homepage = "https://github.com/flameshot-org/flameshot";
    maintainers = with maintainers; [ scode ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
