{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, autoPatchelfHook
, qtbase, libvirt, cutelyst, grantlee }:

stdenv.mkDerivation rec {
  name = "virtlyst-${version}";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "cutelyst";
    repo = "Virtlyst";
    rev = "v${version}";
    sha256 = "1vgjai34hqppkpl0ryxkyhpm9dsx1chs3bii3wc3h40hl80n6dgy";
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
