{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lazydocker";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazydocker";
    rev = "v${version}";
    sha256 = "0f062xn58dbci22pg6y4ifcdfs8whzlv2jjprxxk2ygzixrrjwnc";
  };

  modSha256 = "02n0lg28icy11a2j2rrlmp70blby0kmjas5j48jwh9h9a0yplqic";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A simple terminal UI for both docker and docker-compose";
    homepage = https://github.com/jesseduffield/lazydocker;
    license = licenses.mit;
    maintainers = with maintainers; [ das-g ];
  };
}
