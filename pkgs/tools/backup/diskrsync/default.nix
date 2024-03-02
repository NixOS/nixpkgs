{ buildGoModule, fetchFromGitHub, lib, openssh, makeWrapper }:

buildGoModule rec {
  pname = "diskrsync";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "dop251";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hM70WD+M3jwze0IG84WTFf1caOUk2s9DQ7pR+KNIt1M=";
  };

  vendorHash = "sha256-lJaM/sC5/qmmo7Zu7nGR6ZdXa1qw4SuVxawQ+d/m+Aw=";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ makeWrapper ];

  preFixup = ''
    wrapProgram "$out/bin/diskrsync" --argv0 diskrsync --prefix PATH : ${openssh}/bin
  '';

  meta = with lib; {
    description = "Rsync for block devices and disk images";
    homepage = "https://github.com/dop251/diskrsync";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
