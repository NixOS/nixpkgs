{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "neo-cowsay";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "Code-Hex";
    repo = "Neo-cowsay";
    rev = "v${version}";
    sha256 = "0c6lygdqi26mczij41sn8ckc3g6qaakkkh3iasf10a4d07amxci1";
  };

  modSha256 = "063ds35dzv8m4bjk7v1q3f6jwyp7j5jrkrhrl41z1c1mbzzkagkq";

  subPackages = [ "cmd/cowsay" "cmd/cowthink" ];

  meta = with lib; {
    description = "Cowsay reborn, written in Go";
    homepage = "https://github.com/Code-Hex/Neo-cowsay";
    license = with licenses; [artistic1 /* or */ gpl3];
    maintainers = with maintainers; [ filalex77 ];
  };
}
