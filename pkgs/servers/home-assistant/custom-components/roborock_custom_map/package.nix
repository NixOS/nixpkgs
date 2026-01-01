{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "Lash-L";
  domain = "roborock_custom_map";
<<<<<<< HEAD
  version = "0.1.4";
=======
  version = "0.1.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Lash-L";
    repo = "RoborockCustomMap";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-jXkKjjof1/JeT0KDKIC4sX+P7JwWOzajbFOhlq772L8=";
=======
    hash = "sha256-ZKaUTUTN0tTW8bks0TYixfmbEa7A7ERdJ+xZ365HEbU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    description = "This allows you to use the core Roborock integration with the Xiaomi Map Card";
    homepage = "https://github.com/Lash-L/RoborockCustomMap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kranzes ];
  };
}
