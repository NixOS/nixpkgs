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
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "flameshot-org";
    repo = "flameshot";
    rev = "v${version}";
    sha256 = "1ncknjayl6am740f49g0lc28z1zsifbicxz1j1kwps3ksj15nl7a";
  };

  patches = [
    # Support for USE_LAUNCHER_ABSOLUTE_PATH.
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

  # Use relative path for the .desktop file.
  cmakeFlags = [ "-DUSE_LAUNCHER_ABSOLUTE_PATH=OFF" ];

  meta = with lib; {
    description = "Powerful yet simple to use screenshot software";
    homepage = "https://github.com/flameshot-org/flameshot";
    maintainers = with maintainers; [ scode oxalica ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
