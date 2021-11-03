{ stdenv, lib, fetchFromGitHub, buildGoModule
, makeWrapper, git
}:

buildGoModule rec {
  pname = "mycorrhiza";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "bouncepaw";
    repo = "mycorrhiza";
    rev = "v${version}";
    sha256 = "sha256-Z6WRVKva4Iloy0YMm8rWQt35gxc0syGzbWQ/abwe6qA=";
  };

  vendorSha256 = "sha256-i7EaWw6h+T1aQb14Fr8oWY7/xaCbN5dtnqv54mwyA0A=";

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
