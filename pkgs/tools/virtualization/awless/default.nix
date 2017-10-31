{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "awless-${version}";
  version = "0.0.14";

  goPackagePath = "github.com/wallix/awless";

  src = fetchFromGitHub {
    owner  = "wallix";
    repo   = "awless";
    rev    = version;
    sha256 = "1syxw8d9y1b4bdb1arsx05m5mxnd0dqp3nj7fk5j1v7cnnbja3hj";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/wallix/awless/;
    description = "A Mighty CLI for AWS";
    platforms = with platforms; linux ++ darwin;
    license = licenses.asl20;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}
