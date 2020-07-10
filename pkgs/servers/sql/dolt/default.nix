{ stdenv, fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
    pname = "dolt";
    version = "0.18.0";

    src = fetchFromGitHub {
        owner = "liquidata-inc";
        repo = "dolt";
        rev = "v${version}";
        sha256 = "12kvjq3z9bggfmgci3wql4v8sh491dwp6qr768k8kwncqmp3jjvx";
    };

    modRoot = "./go";
    subPackages = [ "cmd/dolt" "cmd/git-dolt" "cmd/git-dolt-smudge" ];
  vendorSha256 = "1lscjp4ih5kxrbqch9164bqrp7lbsir6vg4zcczhvhh0phbcbqjs";

    meta = with lib; {
        description = "Relational database with version control and CLI a-la Git.";
        homepage = "https://github.com/liquidata-inc/dolt";
        license = licenses.asl20;
        maintainers = with maintainers; [ danbst ];
        platforms = platforms.linux ++ platforms.darwin;
    };
}