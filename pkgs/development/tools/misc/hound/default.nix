{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, mercurial
, git
}:

buildGoModule rec {
  pname = "hound";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "hound-search";
    repo = "hound";
    rev = "v${version}";
    sha256 = "sha256-1URhb+ZrtP5eGS2o7lBxvAxQJR/J6oE+pCbJ7sQb0X4=";
  };

  vendorSha256 = "sha256-ZgF/PB3VTPx367JUkhOkSEK1uvqENNG0xuNXvCGENnQ=";

  nativeBuildInputs = [ makeWrapper ];

  # requires network access
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/houndd --prefix PATH : ${lib.makeBinPath [ mercurial git ]}
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Lightning fast code searching made easy";
    license = licenses.mit;
    maintainers = with maintainers; [ grahamc SuperSandro2000 ];
    platforms = platforms.unix;
  };
}
