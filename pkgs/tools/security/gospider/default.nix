{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "gospider";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "jaeles-project";
    repo = "gospider";
    rev = "v${version}";
    sha256 = "112bf0i5rkfssqbc55y46w237c0yilxamm5swys9ywir5k38nn1l";
  };

  vendorSha256 = "0j6pngcdjral95zjxicq2d94xigwjk1vl1birq84j25kjr27yb2n";

  doCheck = false;

  meta = with lib; {
    description = "Fast web spider written in Go";
    homepage = "https://github.com/jaeles-project/gospider";
    license = licenses.mit;
    maintainers = with maintainers; [ htr ];
  };
}
