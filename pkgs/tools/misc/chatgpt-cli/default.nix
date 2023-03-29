{ lib
, fetchFromGitHub
, buildGoModule
,
}:
buildGoModule rec {
  pname = "chatgpt";
  version = "0.6.0-beta";

  src = fetchFromGitHub {
    owner = "j178";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qIa0eU3aFyDC5cm/J/BmZfcJe1DARqAtmpUMqlaqsF4=";
  };

  vendorHash = "sha256-JlBAPHtMm5mq91aOtsNMDu48net9i3W/AxCiKalYkm4=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Interactive CLI for ChatGPT";
    homepage = "https://github.com/j178/chatgpt";
    license = licenses.mit;
    mainProgram = "chatgpt";
    maintainers = with maintainers; [ Ruixi-rebirth ];
  };
}
