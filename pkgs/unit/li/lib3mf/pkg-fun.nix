{ lib, stdenv, fetchFromGitHub, cmake, ninja, automaticcomponenttoolkit
, pkg-config, libzip, gtest, openssl, libuuid, libossp_uuid }:

stdenv.mkDerivation rec {
  pname = "lib3mf";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "3MFConsortium";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WMTTYYgpCIM86a6Jw8iah/YVXN9T5youzEieWL/d+Bc=";
  };

  nativeBuildInputs = [ cmake ninja pkg-config ];

  outputs = [ "out" "dev" ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_INCLUDEDIR=${placeholder "out"}/include/lib3mf"
    "-DUSE_INCLUDED_ZLIB=OFF"
    "-DUSE_INCLUDED_LIBZIP=OFF"
    "-DUSE_INCLUDED_GTEST=OFF"
    "-DUSE_INCLUDED_SSL=OFF"
  ];

  buildInputs = [
    libzip gtest openssl
  ] ++ (if stdenv.isDarwin then [ libossp_uuid ] else [ libuuid ]);

  postPatch = ''
    # fix libdir=''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@
    sed -i 's,=''${\(exec_\)\?prefix}/,=,' lib3mf.pc.in

    # replace bundled binaries
    for i in AutomaticComponentToolkit/bin/act.*; do
      ln -sf ${automaticcomponenttoolkit}/bin/act $i
    done
  '';

  meta = with lib; {
    description = "Reference implementation of the 3D Manufacturing Format file standard";
    homepage = "https://3mf.io/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
