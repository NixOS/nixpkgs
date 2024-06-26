{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

stdenv.mkDerivation rec {
  version = "9.2";
  pname = "tab";

  src = fetchFromGitHub {
    owner = "ivan-tkatchev";
    repo = pname;
    rev = version;
    hash = "sha256-UOXfnpzYMKDdp8EeBo2HsVPGn61hkCqHe8olX9KAgOU=";
  };

  # gcc12; see https://github.com/ivan-tkatchev/tab/commit/673bdac998
  postPatch = ''
    sed '1i#include <cstring>' -i deps.h
  '';

  nativeCheckInputs = [ python3 ];

  doCheck = !stdenv.isDarwin;

  checkTarget = "test";

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin tab
    install -Dm444 -t $out/share/doc/tab docs/*.html

    runHook postInstall
  '';

  meta = with lib; {
    description = "Programming language/shell calculator";
    mainProgram = "tab";
    homepage = "https://tab-lang.xyz";
    license = licenses.boost;
    maintainers = with maintainers; [ mstarzyk ];
    platforms = with platforms; unix;
  };
}
