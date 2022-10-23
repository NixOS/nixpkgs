{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, mercurial
, git
, nixosTests
}:

buildGoModule rec {
  pname = "hound";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "hound-search";
    repo = "hound";
    rev = "v${version}";
    sha256 = "sha256-M1c4lsD7DQo5+RCCDdyn9FeGuGngMsg1qSrxM2wCzpg=";
  };

  vendorSha256 = "sha256-ZgF/PB3VTPx367JUkhOkSEK1uvqENNG0xuNXvCGENnQ=";

  nativeBuildInputs = [ makeWrapper ];

  # requires network access
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/houndd --prefix PATH : ${lib.makeBinPath [ mercurial git ]}
  '';

  passthru.tests = { inherit (nixosTests) hound; };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Lightning fast code searching made easy";
    license = licenses.mit;
    maintainers = with maintainers; [ grahamc SuperSandro2000 ];
    platforms = platforms.unix;
  };
}
