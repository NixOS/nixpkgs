{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go.rice";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "GeertJohan";
    repo = "go.rice";
    rev = "v${version}";
    sha256 = "0m1pkqnx9glf3mlx5jdaby9yxccbl02jpjgpi4m7x1hb4s2gn6vx";
  };

  vendorSha256 = "0cb5phyl2zm1xnkhvisv0lzgknsi93yzmpayg30w7jc6z4icwnw7";

  subPackages = [ "." "rice" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/GeertJohan/go.rice";
    description = "A Go package that makes working with resources such as html, js, css, images, templates very easy.";
    license = licenses.bsd2;
    maintainers = with maintainers; [ blaggacao ];
  };
}

