{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  pyemvue,
}:

buildHomeAssistantComponent rec {
  owner = "magico13";
  domain = "emporia_vue";
<<<<<<< HEAD
  version = "0.11.3";
=======
  version = "0.11.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "magico13";
    repo = "ha-emporia-vue";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-IONV3jmCyVW2lXjenIicNRaJTsAyzRZ5OVmampqFD7A=";
=======
    hash = "sha256-p8rBO+Z64n87NE7BXNSsTT5IA7ba5RzCZjqX05LqD0A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dependencies = [
    pyemvue
  ];

  ignoreVersionRequirement = [
    "pyemvue"
  ];

<<<<<<< HEAD
  meta = {
    description = "Reads data from the Emporia Vue energy monitor into Home Assistant";
    homepage = "https://github.com/magico13/ha-emporia-vue";
    changelog = "https://github.com/magico13/ha-emporia-vue/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ presto8 ];
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Reads data from the Emporia Vue energy monitor into Home Assistant";
    homepage = "https://github.com/magico13/ha-emporia-vue";
    changelog = "https://github.com/magico13/ha-emporia-vue/releases/tag/v${version}";
    maintainers = with maintainers; [ presto8 ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
