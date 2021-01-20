{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.1";
  pname = "snore";

  src = fetchFromGitHub {
    owner = "clamiax";
    repo = pname;
    rev = version;
    sha256 = "1ic1qy6ybnjlkz5rb1hpvq6dcdmxw5xcx34qcadrsfdjizxcv8pp";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "sleep with feedback";
    homepage = "https://github.com/clamiax/snore";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.unix;
  };
}
