{ mkDerivation
, lib
, fetchFromGitHub
, fetchpatch
, qtbase
, cmake
, qttools
, qtsvg
, nix-update-script
}:

mkDerivation rec {
  pname = "flameshot";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "flameshot-org";
    repo = "flameshot";
    rev = "v${version}";
    sha256 = "sha256-rZUiaS32C77tFJmEkw/9MGbVTVscb6LOCyWaWO5FyR4=";
  };

  patches = [
    # Use absolute install path for `Exec=` in the desktop file.
    # This is required since KWin relies on absolute paths in `Exec=` to find a process'
    # corresponding desktop file and check if it's allowed to take screenshot.
    # Should be removed when the next release comes out.
    (fetchpatch {
      url = "https://github.com/flameshot-org/flameshot/commit/1031980ed1e62d24d7f719998b7951d48801e3fa.patch";
      sha256 = "sha256-o8Zz/bBvitXMDFt5rAfubiUPOx+EQ+ITgrfnFM3dFjE=";
    })
    # Fix autostart write path.
    # Should be removed when the next release comes out.
    (fetchpatch {
      url = "https://github.com/flameshot-org/flameshot/commit/7977cbb52c2d785abd0d85d9df5991e8f7cae441.patch";
      sha256 = "sha256-wWa9Y+4flBiggOMuX7KQyL+q3f2cALGeQBGusX2x6sk=";
    })
  ];

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
    maintainers = with maintainers; [ scode oxalica ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
