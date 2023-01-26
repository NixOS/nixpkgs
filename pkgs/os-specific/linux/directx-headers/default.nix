{ stdenv, lib, fetchFromGitHub, meson, ninja }:
stdenv.mkDerivation rec {
  name = "DirectX-Headers";
  version = "1.608.2";
  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "DirectX-Headers";
    rev = "v${version}";
    sha256 = "sha256-F0riTDJpydqe4yhE9GKSSvnRI0Sl3oY2sOP+H/vDHG0=";
  };
  nativeBuildInputs = [ meson ninja ];
  mesonFlags = [
    "-Dbuild-test=false"
  ];
  meta = with lib; {
    maintainers = [ maintainers.cidkidnix ];
    license = [ licenses.mit ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    description = "Official DirectX-Headers from microsoft for DX12";
    homepage = "https://github.com/microsoft/DirectX-Headers";
  };
}
