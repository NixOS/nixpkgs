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
    sha256 = "03h0ad3v9xfigrppbcxiykzgcrv3dnarm7m1vixi2j4n1340f7q6";
  };

  meta = with stdenv.lib; {
    description = "Live coding demos without Context Switching";
    homepage = https://github.com/dgageot/demoit;
    license = licenses.asl20;
    maintainers = [ maintainers.freezeboy ];
  };
}
