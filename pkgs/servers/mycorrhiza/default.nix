{ stdenv, lib, fetchFromGitHub, buildGoModule
, makeWrapper, git
}:

buildGoModule rec {
  pname = "mycorrhiza";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "bouncepaw";
    repo = "mycorrhiza";
    rev = "v${version}";
    sha256 = "1dd18n9lq4wxz7kn1szavigw9098r7rcwz9j53q92mx100fa42q6";
  };

  vendorSha256 = "1s7n0lk3cr4lkay3plvlqfpx2gh03n2afb43gv9lmwljbry9zbss";

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
  };
}
