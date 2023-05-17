{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "muffet";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "muffet";
    rev = "v${version}";
    hash = "sha256-8+aOxrmLc0iM6uQ35Qtn+a8bzNS1zg1AM25hDylvAEQ=";
  };

  vendorHash = "sha256-BmaljudKwALbx8ECVOpXlEi+/3pOt6osRqHvn9Ek/MI=";

  meta = with lib; {
    description = "A website link checker which scrapes and inspects all pages in a website recursively";
    homepage = "https://github.com/raviqqe/muffet";
    changelog = "https://github.com/raviqqe/muffet/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
