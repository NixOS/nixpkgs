{ fetchFromGitHub
, lib
}:
let
  version = "0.17.1";
  srcHash = "sha256:0b9mdzyfn7c6gwgslqk787yyrrcmdjf3282vx2zvhcr3psz0xqwx";
  vendorSha256 = "sha256:1cq4m5a7z64yg3v1c68d15ilw78il6p53vaqzxgn338zjggr3kig";
  yarnSha256 = "sha256-dLkn9xvQ3gixU63g1xvzbY+YI+9YnaGa3D0uGrrpGvI=";
in
{
  inherit version vendorSha256 yarnSha256;

  src = fetchFromGitHub {
    owner = "pomerium";
    repo = "pomerium";
    rev = "v${version}";
    hash = srcHash;
  };

  meta = with lib; {
    homepage = "https://pomerium.io";
    description = "Authenticating reverse proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
