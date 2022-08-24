{ fetchFromGitHub
, lib
}:
let
  version = "0.18.0";
  srcSha256 = "sha256-sM4kM8CqbZjl+RIsezWYVCmjoDKfGl+EQcdEaPKvVHs=";
  vendorSha256 = "sha256-1EWcjfrO3FEypUUKwNwDisogERCuKOvtC7z0mC2JZn4=";
  yarnSha256 = "sha256-Uh0y2Zmy6bSoyL5WMTce01hoH7EvSIniHyIBMxfMvhg=";
in
{
  inherit version vendorSha256 yarnSha256;

  src = fetchFromGitHub {
    owner = "pomerium";
    repo = "pomerium";
    rev = "v${version}";
    sha256 = srcSha256;
  };

  meta = with lib; {
    homepage = "https://pomerium.io";
    description = "Authenticating reverse proxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
