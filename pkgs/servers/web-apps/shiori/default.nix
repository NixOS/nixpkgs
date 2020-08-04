{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "shiori";
  version = "1.5.0";

  vendorSha256 = "1ik5faysc880kz7nymvbmjj006l1fsqfy76036szwzg314v78643";

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
