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
  version = "unstable-2021-10-17";

  src = fetchFromGitHub {
    owner = "flameshot-org";
    repo = "flameshot";
    rev = "7977cbb52c2d785abd0d85d9df5991e8f7cae441";
    sha256 = "1dljxin5zvlzwzdvggn6kf9q08wawlqcfk29kxwcjflx3279fnmr";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  nativeBuildInputs = [ cmake qttools qtsvg ];
  buildInputs = [ qtbase ];

  cmakeFlags = [ "-DUSE_LAUNCHER_ABSOLUTE_PATH:BOOL=OFF" ];

  meta = with lib; {
    description = "Powerful yet simple to use screenshot software";
    homepage = "https://github.com/flameshot-org/flameshot";
    maintainers = with maintainers; [ scode ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
