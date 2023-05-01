{ lib
, fetchFromGitHub
, buildGoModule
,
}:
buildGoModule rec {
  pname = "chatgpt";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "j178";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5tEtkEDQxWFVWyK7uipm20yccCPkCDaMLzS25MmGRbE=";
  };

  vendorHash = "sha256-q1+4KExXth7+UC8h0+M6ChnW7T1j468umi7Q1jwnzgo=";

  subPackages = [ "cmd" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/$pname
  '';

  meta = with lib; {
    description = "Interactive CLI for ChatGPT";
    homepage = "https://github.com/j178/chatgpt";
    license = licenses.mit;
    mainProgram = "chatgpt";
    maintainers = with maintainers; [ Ruixi-rebirth ];
  };
}
