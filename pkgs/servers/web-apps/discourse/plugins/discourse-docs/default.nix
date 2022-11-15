{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-docs";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-docs";
    rev = "c083f0140ae88702dce4988979d55a7f8e5cfe43";
    sha256 = "sha256-MUIHAW/08UYlXUIK7M+IVzJS/HjP5pGeBgHra+9e+ZA=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-docs";
    maintainers = with maintainers; [ dpausp ];
    license = licenses.mit;
    description = "Find and filter knowledge base topics";
  };
}
