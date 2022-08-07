{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "sshs";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "quantumsheep";
    repo = pname;
    rev = version;
    sha256 = "OTyk3EGlpr5k6QSwGmHFoF3cAJKQEEkWJuV53Wi8ook=";
  };

  vendorSha256 = "wClgX08UbItCpWOkWLgmsy7Ad5LlpvXrStN3JHujVww=";

  ldflags = [ "-s" "-w" "-X github.com/quantumsheep/sshs/cmd.Version=${version}" ];

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "Terminal user interface for SSH";
    homepage = "https://github.com/quantumsheep/sshs";
    license = licenses.mit;
    maintainers = with maintainers; [ not-my-segfault ];
  };
}
