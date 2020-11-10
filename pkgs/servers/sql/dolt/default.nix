{ stdenv, fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
    pname = "dolt";
    version = "0.21.1";

    src = fetchFromGitHub {
        owner = "liquidata-inc";
        repo = "dolt";
        rev = "v${version}";
        sha256 = "03fg91r6lxfq58c5843vysaw8hbagiq4r2qxc4nh9w1b3mc71h7v";
    };

    modRoot = "./go";
    subPackages = [ "cmd/dolt" "cmd/git-dolt" "cmd/git-dolt-smudge" ];
  vendorSha256 = "19755xbjxxva574mj0sc7kqqmr4k22bbvf4aj3d0hhcfjpyhn434";

  doCheck = false;

    meta = with lib; {
        description = "Relational database with version control and CLI a-la Git";
        homepage = "https://github.com/liquidata-inc/dolt";
        license = licenses.asl20;
        maintainers = with maintainers; [ danbst ];
        platforms = platforms.linux ++ platforms.darwin;
    };
}
