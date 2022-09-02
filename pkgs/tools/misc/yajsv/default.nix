{ buildGoModule, fetchFromGitHub, lib }:

let version = "1.4.0";
in buildGoModule {
  pname = "yajsv";
  version = version;

  src = fetchFromGitHub {
    owner = "neilpa";
    repo = "yajsv";
    rev = "v${version}";
    sha256 = "0smaij3905fqgcjmnfs58r6silhp3hyv7ccshk7n13fmllmsm7v7";
  };

  patches = [
    ./go.mod.patch
  ];

  vendorSha256 = "0jcm789las02prgl89va8xvvz98sjcyvzd9zqk3mwal656b5r3kz";

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/yajsv -v > /dev/null
  '';

  meta = {
    description = "Yet Another JSON Schema Validator";
    homepage = "https://github.com/neilpa/yajsv";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rycee ];
  };
}
