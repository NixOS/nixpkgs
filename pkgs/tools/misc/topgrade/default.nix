{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pr8bwwxp8zvn89ldsb0qy5asx59kpd7dsp7sjmgnbj2ddizl05n";
  };

  cargoSha256 = "1f5s8nxl450vpfhvshiwvm49q6ph79vb40qqiz0a2i6jdrzhphq3";

  meta = with stdenv.lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/r-darwish/topgrade";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ filalex77 ];
  };
}
