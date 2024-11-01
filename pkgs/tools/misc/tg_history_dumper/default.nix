{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, fioctl }:

buildGoModule rec {
  pname = "tg_history_dumper";
  version = "unstable-2022-06-29";

  src = fetchFromGitHub {
    owner = "3bl3gamer";
    repo = "tg_history_dumper";
    rev = "d5690ecf35b57fe4e5fcb977a984b4dc6b7c4ae0";
    sha256 = "sha256-3hK+UpVVa6AEX0fmSS02OALViUhXeGRKopK3lGrMQ0E=";
  };

  vendorSha256 = "sha256-SncnWd+gkhgDP0qWGoOj04QLiWUEghhoUTx0eCXTyqI=";

  patchPhase = ''
    substituteInPlace main.go \
      --replace "os.Executable()" "os.Getwd()"
  '';

  meta = with lib; {
    description = "Exports messages and media from Telegram dialogs, groups and channels";
    homepage = "https://github.com/3bl3gamer/tg_history_dumper";
#    license = licenses.asl20;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
