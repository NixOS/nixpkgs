{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "glow";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = pname;
    rev = "v${version}";
    sha256 = "16zadrp42y01hi83hg47cw6c9zpw8z4xfssb5pxkmd2ynihaxfv5";
  };

  modSha256 = "1q67j9wg0kgb41zjgdbcrywxbwh597n8shwnwgl2xa6f7fvzpr4f";

  meta = with lib; {
    description = "Render markdown on the CLI, with pizzazz!";
    homepage = "https://github.com/charmbracelet/glow";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
