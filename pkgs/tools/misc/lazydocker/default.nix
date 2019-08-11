{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lazydocker";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazydocker";
    rev = "v${version}";
    sha256 = "0h2c1f9r67i6a8ppspsg1ln9rkm272092aaaw55sd15xxr51s4hb";
  };

  modSha256 = "1lrrwcr95fxk4dlinyg74vqyxwwzagymncfps9bgig5v5d8gdd8j";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A simple terminal UI for both docker and docker-compose";
    homepage = https://github.com/jesseduffield/lazydocker;
    license = licenses.mit;
    maintainers = with maintainers; [ das-g ];
  };
}
