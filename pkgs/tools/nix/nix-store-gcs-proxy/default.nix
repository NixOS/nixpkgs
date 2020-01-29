{ lib, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  pname = "nix-store-gcs-proxy";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = "nix-store-gcs-proxy";
    rev = "v${version}";
    sha256 = "0804p65px4wd7gzxggpdxsazkd1hbz1p15zzaxf9ygc6sh26ncln";
  };

  goPackagePath = "github.com/tweag/nix-store-gcs-proxy";

  goDeps = ./deps.nix;

  meta = {
    description = "A HTTP nix store that proxies requests to Google Storage";
    homepage = "https://github.com/tweag/nix-store-gcs-proxy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
}

