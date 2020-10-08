{ stdenv, fetchFromGitHub, buildGoModule
, pkg-config, ffmpeg, gnutls
}:

buildGoModule rec {
  pname = "livepeer";
  version = "0.5.10";

  runVend = true;
  vendorSha256 = "0i5977skw4b209zvdvgvzfnhqb574067mmfk2gf9y590lgnr86f7";

  src = fetchFromGitHub {
    owner = "livepeer";
    repo = "go-livepeer";
    rev = "v${version}";
    sha256 = "0qccvnk2yyly7ha9lkcpd6zj5n9xnhdjkl3nllb9xziidsq6p65h";
  };

  # livepeer_cli has a vendoring problem
  subPackages = [ "cmd/livepeer" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ffmpeg gnutls ];

  meta = with stdenv.lib; {
    description = "Official Go implementation of the Livepeer protocol";
    homepage = "https://livepeer.org";
    license = licenses.mit;
    maintainers = with maintainers; [ elitak ];
  };
}
