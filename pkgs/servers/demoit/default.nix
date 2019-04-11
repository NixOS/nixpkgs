{ stdenv
, buildGoPackage
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "demoit";
  version = "unstable-2019-03-29";
  goPackagePath = "github.com/dgageot/demoit";

  src = fetchFromGitHub {
    owner = "dgageot";
    repo = "demoit";
    rev = "ec70fbdf5a5e92fa1c06d8f039f7d388e0237ba2";
    sha256 = "01584cxlnrc928sw7ldmi0sm7gixmwnawy3c5hd79rqkw8r0gbk0";
  };

  meta = with stdenv.lib; {
    description = "Live coding demos without Context Switching";
    homepage = https://github.com/dgageot/demoit;
    license = licenses.asl20;
    maintainers = [ maintainers.freezeboy ];
  };
}
