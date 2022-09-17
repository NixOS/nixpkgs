{ stdenv, lib, fetchFromGitHub, buildGoModule
, makeWrapper, git
}:

buildGoModule rec {
  pname = "mycorrhiza";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "bouncepaw";
    repo = "mycorrhiza";
    rev = "v${version}";
    sha256 = "sha256-uPnIp4Fc2vXwZnr19jQf39rReutzUqXO9EsXhjt1TuA=";
  };

  vendorSha256 = "sha256-be9Et2hAW3xntt9AHN9xfc9dBW/MCvpdl0XdTJKRIy4=";

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
