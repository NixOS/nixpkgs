{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  ulid-transform,
}:

buildHomeAssistantComponent rec {
  owner = "basnijholt";
  domain = "adaptive_lighting";
<<<<<<< HEAD
  version = "1.29.0";
=======
  version = "1.28.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "basnijholt";
    repo = "adaptive-lighting";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-v10Mrc/sSB09mC0UHMhjoEnPhj5S3tISmMcPQrPHPq8=";
=======
    hash = "sha256-FyDspw/Sk7h5Kh3lq17DmGbkJlVP0CLfAX0GL7DVF0k=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dependencies = [
    ulid-transform
  ];

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/basnijholt/adaptive-lighting/releases/tag/${src.tag}";
    description = "Home Assistant Adaptive Lighting Plugin - Sun Synchronized Lighting";
    homepage = "https://github.com/basnijholt/adaptive-lighting";
    maintainers = with lib.maintainers; [ mindstorms6 ];
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    changelog = "https://github.com/basnijholt/adaptive-lighting/releases/tag/${src.tag}";
    description = "Home Assistant Adaptive Lighting Plugin - Sun Synchronized Lighting";
    homepage = "https://github.com/basnijholt/adaptive-lighting";
    maintainers = with maintainers; [ mindstorms6 ];
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
