{ stdenv, lib, fetchFromGitHub, buildGoModule
, makeWrapper, git
}:

buildGoModule rec {
  pname = "mycorrhiza";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "bouncepaw";
    repo = "mycorrhiza";
    rev = "v${version}";
    sha256 = "sha256-ovlLOacVhf8phL9LNrMf55oo5KgaCKYeS/of/abE8Bo=";
  };

  vendorHash = "sha256-0O831ILIwv2uyTU23x+tnLbUbkrp9ew316uPmqjhxWM=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/mycorrhiza \
      --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  meta = with lib; {
    description = "Filesystem and git-based wiki engine written in Go using mycomarkup as its primary markup language";
    homepage = "https://github.com/bouncepaw/mycorrhiza";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ chekoopa ];
    platforms = platforms.linux;
    mainProgram = "mycorrhiza";
  };
}
