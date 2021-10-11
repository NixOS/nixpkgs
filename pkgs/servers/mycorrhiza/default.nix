{ stdenv, lib, fetchFromGitHub, buildGoModule
, makeWrapper, git
}:

buildGoModule rec {
  pname = "mycorrhiza";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "bouncepaw";
    repo = "mycorrhiza";
    rev = "v${version}";
    sha256 = "0manay7gfybzk28dp9a8xdfpbhxm1dbnvcyp4mjhh449n8jlp4bq";
  };

  vendorSha256 = "1br1p8cnyv2xpwnld3ydd87zxbdwl962f6yww8i8xbsm7881bl0d";

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
