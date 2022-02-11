{ fetchFromGitHub, gtk3, lib, pkg-config, stdenv }:

stdenv.mkDerivation rec {
  pname = "iwgtk";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "j-lentz";
    repo = pname;
    rev = "v${version}";
    sha256 = "129h7vq9b1r9a5c79hk8d06bj8lgzrnhq55x54hqri9c471jjh0s";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "Lightweight, graphical wifi management utility for Linux";
    homepage = "https://github.com/j-lentz/iwgtk";
    changelog = "https://github.com/j-lentz/iwgtk/blob/v${version}/CHANGELOG";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ figsoda ];
  };
}
