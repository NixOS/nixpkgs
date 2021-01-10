{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "psw";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "Wulfsta";
    repo = pname;
    rev = version;
    sha256 = "10raj4899i01f5v13w0wxdnjjicql2wjblkq1zcagrfv3ly3d0fy";
  };

  cargoSha256 = "1w18rym0xnjk7vhrb2dc4cvhg659zbq5d2153gw2snxcbs7gh7r1";

  meta = with lib; {
    description = "A command line tool to write random bytes to stdout";
    homepage = "https://github.com/Wulfsta/psw";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ wulfsta ];
    platforms = platforms.linux;
  };
}
