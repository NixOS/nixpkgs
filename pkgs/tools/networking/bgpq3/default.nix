{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "bgpq3";
  version = "0.1.35";

  src = fetchFromGitHub {
    owner = "snar";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fd5a3krq0i906m0iivgphiqq88cw6c0w1q4n7lmzyq9201mb8wj";
  };

  # Fix binary install location. Remove with next upstream release.
  preInstall = "mkdir -p $out/bin";

  meta = with stdenv.lib; {
    description = "bgp filtering automation tool";
    homepage = "https://github.com/snar/bgpq3";
    license = licenses.bsd2;
    maintainers = with maintainers; [ b4dm4n ];
    platforms = with platforms; unix;
  };
}
