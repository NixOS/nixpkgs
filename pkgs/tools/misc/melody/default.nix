{ lib, stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "melody";
  version = "0.18.0";

  src = fetchCrate {
    pname = "melody_cli";
    inherit version;
    sha256 = "1shd5m9sj9ybjzq26ipggfbc22lyzkdzq2kirgfvdk16m5r3jy2v";
  };

  cargoSha256 = "0wz696zz7gm36dy3lxxwsiriqxk0nisdwybvknn9a38rvzd6jjbm";

  meta = with lib; {
    description = "Language that compiles to regular expressions";
    homepage = "https://github.com/yoav-lavi/melody";
    license = licenses.mit;
    maintainers = with maintainers; [ jyooru ];
  };
}
