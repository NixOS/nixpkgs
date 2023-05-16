{ lib, stdenv, fetchFromGitHub, cmake, python3 }:

stdenv.mkDerivation (finalAttrs: {
  pname = "spirv-cross";
<<<<<<< HEAD
  version = "1.3.261.0";
=======
  version = "1.3.243.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Cross";
    rev = "sdk-${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-abVqLovvcKBJhGhSCbyD5mc1DSfvh4TWssGxi52ukQ8=";
=======
    hash = "sha256-snxbTI4q0YQq8T5NQD3kcsN59iJnhlLiu1Fvr+fCDeQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake python3 ];

<<<<<<< HEAD
  postFixup = ''
    substituteInPlace $out/lib/pkgconfig/*.pc \
      --replace '=''${prefix}//' '=/'
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A tool designed for parsing and converting SPIR-V to other shader languages";
    homepage = "https://github.com/KhronosGroup/SPIRV-Cross";
    changelog = "https://github.com/KhronosGroup/SPIRV-Cross/releases/tag/${version}";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ Flakebi ];
  };
})
