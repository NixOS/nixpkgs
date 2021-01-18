{ stdenv, fetchFromGitHub
, cmake, pkg-config, gtest
, boost, wayland
}:

stdenv.mkDerivation rec {
  pname = "wlcs";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "MirServer";
    repo = "wlcs";
    rev = "v${version}";
    sha256 = "1l6m7gbdjicdv38ynxjpgxmzb5adafc5z9qdq9176b0vrg1wjn5y";
  };

  postPatch = ''
    substituteInPlace cmake/FindGtestGmock.cmake \
      --replace "REPLACE gtest gmock" "REPLACE libgtest.so libgmock.so"
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ boost wayland gtest ];

  postInstall = ''
    substituteInPlace $out/lib/pkgconfig/wlcs.pc \
      --replace "prefix}/$out" 'prefix}'
  '';

  meta = with stdenv.lib; {
    description = "Wayland Conformance Test Suite";
    longDescription = ''
      wlcs aspires to be a protocol-conformance-verifying test suite usable by Wayland
      compositor implementors.
    '';
    homepage = "https://github.com/MirServer/wlcs";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
