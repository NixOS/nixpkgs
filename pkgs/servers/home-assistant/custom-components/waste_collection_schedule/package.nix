{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  beautifulsoup4,
<<<<<<< HEAD
  cloudscraper,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  icalendar,
  icalevents,
  lxml,
  pycryptodome,
  pypdf,
}:

buildHomeAssistantComponent rec {
  owner = "mampfes";
  domain = "waste_collection_schedule";
<<<<<<< HEAD
  version = "2.11.0";
=======
  version = "2.10.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    inherit owner;
    repo = "hacs_waste_collection_schedule";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-+yt6kjUV+fqbOa7jj603XdGX7XtI8mXnCnmUjYFNA7c=";
=======
    hash = "sha256-qFeo2VE0sgBq4dwOUm26Vkgi+rv/0PsOyQhlVEJ45aE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dependencies = [
    beautifulsoup4
<<<<<<< HEAD
    cloudscraper
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    icalendar
    icalevents
    lxml
    pycryptodome
    pypdf
  ];

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/mampfes/hacs_waste_collection_schedule/releases/tag/${version}";
    description = "Home Assistant integration framework for (garbage collection) schedules";
    homepage = "https://github.com/mampfes/hacs_waste_collection_schedule";
    maintainers = with lib.maintainers; [ jamiemagee ];
    license = lib.licenses.mit;
=======
  meta = with lib; {
    changelog = "https://github.com/mampfes/hacs_waste_collection_schedule/releases/tag/${version}";
    description = "Home Assistant integration framework for (garbage collection) schedules";
    homepage = "https://github.com/mampfes/hacs_waste_collection_schedule";
    maintainers = with maintainers; [ jamiemagee ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
