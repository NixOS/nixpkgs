{ lib
, fetchFromGitHub
, buildGoModule
,
}:
buildGoModule rec {
  pname = "chatgpt";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "j178";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7PQ390KX/+Yu730pluO+jL1NNZ1yB1CO+YTj41/OByo=";
  };

  vendorHash = "sha256-MSqCFcBY6z16neinGsxH+YFA7R2p+4kwolgqGxjQVq4=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Interactive CLI for ChatGPT";
    homepage = "https://github.com/j178/chatgpt";
    license = licenses.mit;
    mainProgram = "chatgpt";
    maintainers = with maintainers; [ Ruixi-rebirth ];
  };
}
