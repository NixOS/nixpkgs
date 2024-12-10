{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "chatgpt";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "j178";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PwC/LyWGgFdj1aye8A/W9wc78z9mEbvz4DNsB0eHtl0=";
  };

  vendorHash = "sha256-hmg301m4Zn7BzlOJ6VVySkxwFt7CDT7MS9EH1JqeW/E=";

  subPackages = [ "cmd/chatgpt" ];

  meta = with lib; {
    description = "Interactive CLI for ChatGPT";
    homepage = "https://github.com/j178/chatgpt";
    license = licenses.mit;
    mainProgram = "chatgpt";
    maintainers = with maintainers; [ Ruixi-rebirth ];
  };
}
