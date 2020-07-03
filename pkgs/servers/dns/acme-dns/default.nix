{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "acme-dns";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "joohoi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jt4sKwC0Ws6HMFG6+EdeMLZsmmy1UhVihUARzd1EU+w=";
  };

  vendorSha256 = "sha256-jWkW7cuP0kd2ukdEJt92jMHWKwbCKL54tgEaVuo+SHs=";

  meta = {
    description = "Limited DNS server to handle ACME DNS challenges easily and securely";
    inherit (src.meta) homepage;
    changelog = "${meta.homepage}/blob/v${version}/README.md#changelog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emily ];
    platforms = lib.platforms.all;
  };
}
