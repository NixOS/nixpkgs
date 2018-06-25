{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, autoPatchelfHook
, qtbase, libvirt, cutelyst, grantlee }:

stdenv.mkDerivation rec {
  name = "virtlyst-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "cutelyst";
    repo = "Virtlyst";
    rev = "v${version}";
    sha256 = "1rqv93dys666wsqbg1lvl3pjl8gpdx3dc3y71m3r8apalgr11ikw";
  };

  nativeBuildInputs = [ cmake pkgconfig autoPatchelfHook ];
  buildInputs = [ qtbase libvirt cutelyst grantlee ];

  installPhase = ''
    mkdir -p $out/lib
    cp src/libVirtlyst.so $out/lib
    cp -r ../root $out
  '';

  patches = [ ./add-admin-password-env.patch ];

  meta = with lib; {
    description = "Web interface to manage virtual machines with libvirt";
    homepage = https://github.com/cutelyst/Virtlyst;
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ fpletz ];
  };
}
