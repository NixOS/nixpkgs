{ lib, makeWrapper, buildGoModule, fetchFromGitHub, lepton }:

buildGoModule {
  pname = "gb-backup";
  version = "unstable-2021-10-27";

  src = fetchFromGitHub {
    owner = "leijurv";
    repo = "gb";
    rev = "61383d445af7b035fb8e1df0cacc424340dd16df";
    sha256 = "sha256-YRrD2gW+gzxD2JwadCbF/SBSsHeeGPsa8kKZHHAytVo=";
  };

  vendorSha256 = "sha256-H3Zf4VNJVX9C3GTeqU4YhNqCIQz1R55MfhrygDgJTxc=";

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [ lepton ];

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
