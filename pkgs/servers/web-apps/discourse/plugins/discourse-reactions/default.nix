{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-reactions";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-reactions";
    rev = "f04f077e9f0392ca2373ca001044069d650ae6e5";
    sha256 = "sha256-HuFXgfd5HO7qfVlf1RHxenlNL10YRF5OYya4Yt6eS14=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-reactions";
    maintainers = with maintainers; [ bbenno ];
    license = licenses.mit;
    description = "Allows users to react to a post from a choice of emojis, rather than only the like heart";
  };
}
