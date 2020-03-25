{ stdenv, buildGoModule, fetchFromGitHub, Security }:

buildGoModule rec {
  pname = "shiori";
  version = "1.5.0";

  modSha256 = "1z6q5lv0j433p8lc3nxlw1rds5x1kvs1vzl63jf3disxw7ppyai3";

  src = fetchFromGitHub {
    owner = "go-shiori";
    repo = pname;
    rev = "v${version}";
    sha256 = "13and7gh2882khqppwz3wwq44p7az4bfdfjvlnqcpqyi8xa28pmq";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "Simple bookmark manager built with Go";
    homepage = "https://github.com/go-shiori/shiori";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson ];
  };
}
