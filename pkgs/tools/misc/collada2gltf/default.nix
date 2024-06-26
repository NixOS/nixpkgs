{ fetchFromGitHub
, lib
, stdenv
, cmake
, ninja
}:
stdenv.mkDerivation rec {
  pname = "COLLADA2GLTF";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-3Eo1qS6S5vlc/d2WB4iDJTjUnwMUrx9+Ln6n8PYU5qA=";
    fetchSubmodules = true;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp COLLADA2GLTF-bin $out/bin/COLLADA2GLTF

    runHook postInstall
  '';

  nativeBuildInputs = [
    cmake
    ninja
  ];

  meta = {
    description = "COLLADA to glTF converter";
    longDescription = ''
      A command-line tool to convert COLLADA (.dae) files to glTF.
    '';
    homepage = "https://github.com/KhronosGroup/COLLADA2GLTF";
    license = lib.licenses.bsd3;
    mainProgram = "COLLADA2GLTF";
    maintainers = with lib.maintainers; [ shaddydc ];
  };
}
