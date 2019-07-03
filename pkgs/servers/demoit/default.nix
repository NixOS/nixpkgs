{ stdenv
, buildGoPackage
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "demoit";
  version = "unstable-2019-05-10";
  goPackagePath = "github.com/dgageot/demoit";

  src = fetchFromGitHub {
    owner = "dgageot";
    repo = "demoit";
    rev = "c1d4780620ebf083cb4a81b83c80e7547ff7bc23";
    sha256 = "0l0pw0kzgnrk6a6f4ls3s82icjp7q9djbaxwfpjswbcfdzrsk4p2";
  };

  meta = with stdenv.lib; {
    description = "Live coding demos without Context Switching";
    homepage = https://github.com/dgageot/demoit;
    license = licenses.asl20;
    maintainers = [ maintainers.freezeboy ];
  };
}
