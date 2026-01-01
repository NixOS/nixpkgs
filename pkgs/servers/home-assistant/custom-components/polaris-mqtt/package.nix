{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "samoswall";
  domain = "polaris";
<<<<<<< HEAD
  version = "1.0.13";
=======
  version = "1.0.12";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "samoswall";
    repo = "polaris-mqtt";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-SpnrEW/gzUMZXlnoyzOC4/8ooIxUqrcRNIAdBzUR4oY=";
=======
    hash = "sha256-LH5as1HaD+fgj2ZJ8su7Jz1lE+Dh0iJHZilOUoiy7jo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    description = "Polaris IQ Home devices integration to Home Assistant";
    homepage = "https://github.com/samoswall/polaris-mqtt";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.k900 ];
  };
}
