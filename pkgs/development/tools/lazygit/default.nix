{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lazygit";
  version = "0.23.2";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-G/oAKIG0TSEjaVi6vN2wg/apOztGLiqqYLfZy6Tmmgc=";
  };

  vendorSha256 = null;
  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-X main.version=${version} -X main.buildSource=nix" ];

  meta = with stdenv.lib; {
    description = "Simple terminal UI for git commands";
    homepage = "https://github.com/jesseduffield/lazygit";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz equirosa filalex77 ];
  };
}
