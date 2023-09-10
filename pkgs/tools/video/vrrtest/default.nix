{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, zip
, love
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vrrtest";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "Nixola";
    repo = "VRRTest";
    rev = "v${finalAttrs.version}";
    hash = "sha256-esyD+BpdnB8miUrIjV6P8Lho1xztmhLDnKxdQKW8GXc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ zip ];

  buildPhase = ''
    runHook preBuild
    zip -9 -r vrrtest.love .
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm444 -t $out/share/ vrrtest.love
    makeWrapper ${love}/bin/love $out/bin/vrrtest \
      --add-flags $out/share/vrrtest.love
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool testing variable refresh rates";
    homepage = "https://github.com/Nixola/VRRTest";
    license = licenses.zlib;
    mainProgram = "vrrtest";
    maintainers = with maintainers; [ justinlime ];
    inherit (love.meta) platforms;
  };
})
