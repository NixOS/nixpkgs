{ stdenv, fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
    pname = "dolt";
    version = "0.22.0";

    src = fetchFromGitHub {
        owner = "liquidata-inc";
        repo = "dolt";
        rev = "v${version}";
        sha256 = "14km34wjhijfwxvqcplf2jmh69zj7llsrimafmz94jy8cy85cpa1";
    };

    modRoot = "./go";
    subPackages = [ "cmd/dolt" "cmd/git-dolt" "cmd/git-dolt-smudge" ];
  vendorSha256 = "01lf5f2iigv8pihblwxyqx0pgj6gqir3b7rcna0xkirrfpvzd38c";

  doCheck = false;

    meta = with lib; {
        description = "Relational database with version control and CLI a-la Git";
        homepage = "https://github.com/liquidata-inc/dolt";
        license = licenses.asl20;
        maintainers = with maintainers; [ danbst ];
        platforms = platforms.linux ++ platforms.darwin;
    };
}
