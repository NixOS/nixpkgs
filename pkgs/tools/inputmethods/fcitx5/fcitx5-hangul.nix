{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, gettext
, fcitx5
, libhangul
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-hangul";
  version = "5.0.11";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    sha256 = "sha256-VA9LDGMJRJDDCxIsx7wpDgdc2V9cuWlydAq5yiIvpxA=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gettext
  ];

  buildInputs = [
    fcitx5
    libhangul
  ];

  meta = with lib; {
    description = "Hangul wrapper for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-hangul";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.linux;
  };
}
