{ lib, makeWrapper, buildGoModule, fetchFromGitHub, lepton }:

buildGoModule {
  pname = "gb-backup";
  version = "unstable-2021-04-07";

  src = fetchFromGitHub {
    owner = "leijurv";
    repo = "gb";
    rev = "904813bf0bbce048af5795618d58c0b1953f9ff8";
    sha256 = "111jrcv4x38sc19xha5q3pd2297s13qh1maa7sa1k09hgypvgsxf";
  };

  vendorSha256 = "0m2aa6p04b4fs7zncar1mlykc94pp527phv71cdsbx58jgsm1jnx";

  nativeBuildInputs = [ makeWrapper ];

  checkInputs = [ lepton ];

  postFixup = ''
    wrapProgram $out/bin/gb --prefix PATH : ${lib.makeBinPath [ lepton ]}
  '';

  meta = with lib; {
    description = "Gamer Backup, a super opinionated cloud backup system";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ babbaj ];
    platforms = platforms.unix;
  };
}
