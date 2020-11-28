{ stdenv, fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
    pname = "dolt";
    version = "0.22.1";

    src = fetchFromGitHub {
        owner = "liquidata-inc";
        repo = "dolt";
        rev = "v${version}";
        sha256 = "1n0yxnjxlz2bvybdvba8cqqv702ry3crq114l2bni7q7llfs5y08";
    };

    modRoot = "./go";
    subPackages = [ "cmd/dolt" "cmd/git-dolt" "cmd/git-dolt-smudge" ];
  vendorSha256 = "0avk20g7ic1gw1qr8bp4rbl7m822q2kphwc9f6ld6p5yl6pwqv3h";

  doCheck = false;

    meta = with lib; {
        description = "Relational database with version control and CLI a-la Git";
        homepage = "https://github.com/liquidata-inc/dolt";
        license = licenses.asl20;
        maintainers = with maintainers; [ danbst ];
        platforms = platforms.linux ++ platforms.darwin;
    };
}
