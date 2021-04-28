{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "dapr";
  version = "1.1.0";

  vendorSha256 = "0fng5a1pvpbwil79xapdalzgkgc9dwsdxs6bznjfwnkyd1vvw6fm";

  src = fetchFromGitHub {
    sha256 = "0x2mvlzlmcik6ys6xp722px9l4lj9ssyxb06bzxd7yj7m1wwcwp9";

    owner = "dapr";
    repo = "cli";
    rev = "v${version}";
  };

  doCheck = false;

  postInstall = ''
    mv $out/bin/cli $out/bin/dapr
  '';

  meta = with lib; {
    homepage = "https://dapr.io";
    description = "A CLI for managing Dapr, the distributed application runtime";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
