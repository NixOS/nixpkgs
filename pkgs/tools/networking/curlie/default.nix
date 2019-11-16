{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "curlie";
  version = "1.2.0";

  src= fetchFromGitHub {
    owner = "rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jgwd1amwjpmfgg08j9m9i15rpxijhmld9najzqb2gf8c1n5d8cf";
  };

  modSha256 = "18nwq99vv3nbdwfilfn8v64mn58jviwybi93li0lcg7779nxab3d";

  meta = with lib; {
    description = "Curlie is a frontend to curl that adds the ease of use of httpie, without compromising on features and performance";
    homepage = https://curlie.io/;
    maintainers = with maintainers; [ ma27 ];
    license = licenses.mit;
  };
}
