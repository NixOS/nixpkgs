{ stdenv, fetchFromGitHub, crystal, shards, which
, openssl, readline }:

stdenv.mkDerivation rec {
  pname = "icr";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner  = "crystal-community";
    repo   = "icr";
    rev    = "v${version}";
    sha256 = "1vavdzgm06ssnxm6mylki6xma0mfsj63n5kivhk1v4pg4xj966w5";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace /usr/local $out
  '';

  buildInputs = [ openssl readline ];

  nativeBuildInputs = [ crystal shards which ];

  doCheck = true;

  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "Interactive console for the Crystal programming language";
    homepage = https://github.com/crystal-community/icr;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
