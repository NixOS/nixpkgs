{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "conftest";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "instrumenta";
    repo = "conftest";
    rev = "v${version}";
    sha256 = "15xzldcmnpfg1hd5zr5i7x2zjrgkwnp4nylxbn9kfic2dpjp1a38";
  };

  vendorSha256 = "1kay7b5rxypj4i0d2iwdlb1mj0qq3zvlrjp34zzv5kywz5gy4144";

  buildFlagsArray = ''
    -ldflags=
        -X main.version=${version}
  '';

  meta = with lib; {
    description = "Write tests against structured configuration data";
    homepage = "https://github.com/instrumenta/conftest";
    license = licenses.asl20;
    maintainers = with maintainers; [ yurrriq ];
    platforms = platforms.all;
  };
}