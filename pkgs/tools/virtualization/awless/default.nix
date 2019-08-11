{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "awless-${version}";
  version = "0.1.11";

  goPackagePath = "github.com/wallix/awless";

  src = fetchFromGitHub {
    owner  = "wallix";
    repo   = "awless";
    rev    = "v${version}";
    sha256 = "187i21yrm10r3f5naj3jl0rmydr5dkhmdhxs90hhf8hjp59a89kg";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/wallix/awless/;
    description = "A Mighty CLI for AWS";
    platforms = with platforms; linux ++ darwin;
    license = licenses.asl20;
    maintainers = with maintainers; [ pradeepchhetri swdunlop ];
  };
}
