{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-checklist";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-checklist";
    rev = "6fcf9fed5c3ae3baf9ddd1cca9cef4dc089996c1";
    sha256 = "sha256-RIuoqZo7dW1DXbfbWhyyhCOGe4R5sLerzFW2TT0zO6U=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-checklist";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.gpl2Only;
    description = "Simple checklist rendering plugin for discourse";
  };
}
