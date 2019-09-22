{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "shiori";
  version = "1.5.0";

  modSha256 = "142raxqh6mipw0dyhzgc8ha6vn74wdin25qrl1nkd68mpcvsbblg";

  src = fetchFromGitHub {
    owner = "go-shiori";
    repo = pname;
    rev = "v${version}";
    sha256 = "13and7gh2882khqppwz3wwq44p7az4bfdfjvlnqcpqyi8xa28pmq";
  };

  meta = with stdenv.lib; {
    description = "Simple bookmark manager built with Go";
    homepage = "https://github.com/go-shiori/shiori";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson ];
  };
}
