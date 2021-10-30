{ lib, makeWrapper, buildGoModule, fetchFromGitHub, lepton }:

buildGoModule {
  pname = "gb-backup";
  version = "unstable-2021-08-16";

  src = fetchFromGitHub {
    owner = "leijurv";
    repo = "gb";
    rev = "fa996208d06766bf523686fbe5831628130d80f7";
    sha256 = "1vggl8d69sf4z2lmixfndwwd6l9gi0fkkrxga7v4w7a7yr96b1vp";
  };

  vendorSha256 = "0m2aa6p04b4fs7zncar1mlykc94pp527phv71cdsbx58jgsm1jnx";

  nativeBuildInputs = [ makeWrapper ];

  checkInputs = [ lepton ];

  postFixup = ''
    wrapProgram $out/bin/gb --prefix PATH : ${lib.makeBinPath [ lepton ]}
  '';

  meta = with lib; {
    description = "Gamer Backup, a super opinionated cloud backup system";
    homepage = "https://github.com/leijurv/gb";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ babbaj ];
    platforms = platforms.unix;
  };
}
