{ stdenv, fetchFromGitHub, crystal, shards, which
, openssl, readline, libyaml }:

stdenv.mkDerivation rec {
  pname = "icr";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner  = "crystal-community";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0kkdqrxk4f4bqbb84mgjrk9r0fz1hsz95apvjsc49gav4c8xx3mb";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace /usr/local $out
  '';

  buildInputs = [ crystal libyaml openssl readline ];

  nativeBuildInputs = [ shards which ];

  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "Interactive console for the Crystal programming language";
    homepage = "https://github.com/crystal-community/icr";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
