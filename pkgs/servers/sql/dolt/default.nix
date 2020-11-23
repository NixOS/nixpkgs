{ stdenv, fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
    pname = "dolt";
    version = "0.21.4";

    src = fetchFromGitHub {
        owner = "liquidata-inc";
        repo = "dolt";
        rev = "v${version}";
        sha256 = "13dr3iq3v14i9zlcpv8yvq6yp90b70512bk2jkr5arlk2bilba8c";
    };

    modRoot = "./go";
    subPackages = [ "cmd/dolt" "cmd/git-dolt" "cmd/git-dolt-smudge" ];
  vendorSha256 = "1x3a4q629jrgh7x8b81n2iapbxjfd389pj1wc2zd6c5l9r70xr97";

  doCheck = false;

    meta = with lib; {
        description = "Relational database with version control and CLI a-la Git";
        homepage = "https://github.com/liquidata-inc/dolt";
        license = licenses.asl20;
        maintainers = with maintainers; [ danbst ];
        platforms = platforms.linux ++ platforms.darwin;
    };
}
