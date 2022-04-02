{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-saved-searches";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-saved-searches";
    rev = "baf1ab94317129d2ff2eb4e5e6d84fa76c40797c";
    sha256 = "sha256-6NP9TK5Wx0LPX0ZFIiaEEYJv3d9WIQ26nvODk0dU2I0=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-saved-searches";
    maintainers = with maintainers; [ dpausp ];
    license = licenses.mit;
    description = "Allow users to save searches and be notified of new results";
  };
}
