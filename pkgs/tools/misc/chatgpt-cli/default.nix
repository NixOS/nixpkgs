{ lib
, fetchFromGitHub
, buildGoModule
,
}:
buildGoModule rec {
  pname = "chatgpt";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "j178";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sGcVtppw1q05ICcYyRcF2gpFCzbBftaxAM4X4/k48as=";
  };

  vendorHash = "sha256-lD9G8N1BpWda2FAi80qzvdiQXoJIWl529THYMfQmXtg=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Interactive CLI for ChatGPT";
    homepage = "https://github.com/j178/chatgpt";
    license = licenses.mit;
    mainProgram = "chatgpt";
    maintainers = with maintainers; [ Ruixi-rebirth ];
  };
}
