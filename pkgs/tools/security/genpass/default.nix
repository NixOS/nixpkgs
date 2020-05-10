{ stdenv
, fetchFromGitHub
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "genpass";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "cyplo";
    repo = pname;
    rev = "v${version}";
    sha256 = "1b22m7g55k5ry0vwyd8pakh8rmfkhk37qy5r74cn3n5pv3fcwini";
  };

  cargoSha256 = "1p6l64s9smhwka8bh3pamqimamxziad859i62nrmxzqc49nq5s7m";

  meta = with stdenv.lib; {
    description = "A simple yet robust commandline random password generator.";
    homepage = "https://github.com/cyplo/genpass";
    license = licenses.agpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ cyplo ];
  };
}
