{ lib
, fetchFromGitHub
, buildGoModule
,
}:
buildGoModule rec {
  pname = "chatgpt";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "j178";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HhpllMpr9VvtpaFMDPPQpJLyyJhKI4uWQswsFLrMhos=";
  };

  vendorHash = "sha256-QsK2ghfmhqSDCPiQz0/bdGJvxijDGSi4kAG6f8hJyrg=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Interactive CLI for ChatGPT";
    homepage = "https://github.com/j178/chatgpt";
    license = licenses.mit;
    mainProgram = "chatgpt";
    maintainers = with maintainers; [ Ruixi-rebirth ];
  };
}
