{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "hcledit";
  version = "0.2.14";

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7Yay4a55AIzhJHkUh3lCNjklPOZm9VwrmAAyLIW6XJ0=";
  };

  vendorHash = "sha256-G6jmdosQHBA+n7MgVAlzdSTqPYb5d+k4b4EzAI384FQ=";

  meta = with lib; {
    description = "Command line editor for HCL";
    mainProgram = "hcledit";
    homepage = "https://github.com/minamijoyo/hcledit";
    license = licenses.mit;
    maintainers = with maintainers; [ aleksana ];
  };
}
