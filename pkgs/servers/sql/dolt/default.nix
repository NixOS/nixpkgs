{ stdenv, fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
    pname = "dolt";
    version = "0.18.3";

    src = fetchFromGitHub {
        owner = "liquidata-inc";
        repo = "dolt";
        rev = "v${version}";
        sha256 = "0mgawr3nkyna22sqhskvvk7h9c8ivag959liji2qcdfwgfqp0l6z";
    };

    modRoot = "./go";
    subPackages = [ "cmd/dolt" "cmd/git-dolt" "cmd/git-dolt-smudge" ];
  vendorSha256 = "0rqkqyvf8mjl7b62ng7vzi6as6qw3sg3lzj2mcg1aiw3h7ikr6hw";

  doCheck = false;

    meta = with lib; {
        description = "Relational database with version control and CLI a-la Git.";
        homepage = "https://github.com/liquidata-inc/dolt";
        license = licenses.asl20;
        maintainers = with maintainers; [ danbst ];
        platforms = platforms.linux ++ platforms.darwin;
    };
}
