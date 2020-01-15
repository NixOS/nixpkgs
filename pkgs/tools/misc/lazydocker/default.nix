{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lazydocker";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazydocker";
    rev = "v${version}";
    sha256 = "0vai88g31yf55988paqzs7fqlxgi0ydrsgszzjig9ai3x9c52xim";
  };

  modSha256 = "1iin1m6s9xxdskvj6jy2jwlqrsrm432ld13cpa28hpx7pylx61ij";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A simple terminal UI for both docker and docker-compose";
    homepage = https://github.com/jesseduffield/lazydocker;
    license = licenses.mit;
    maintainers = with maintainers; [ das-g ];
  };
}
