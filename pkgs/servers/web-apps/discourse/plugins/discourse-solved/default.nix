{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-solved";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-solved";
    rev = "a18ce6d712fafed286bcc99543dd173110c6dfb8";
    sha256 = "sha256-MUkQ/6ChMGqSNFZO2t8amecrYZbK1OyVq5lhPeB99ow=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-solved";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Allow accepted answers on topics";
  };
}
