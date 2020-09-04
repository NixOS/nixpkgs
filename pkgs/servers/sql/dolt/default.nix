{ stdenv, fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
    pname = "dolt";
    version = "0.19.0";

    src = fetchFromGitHub {
        owner = "liquidata-inc";
        repo = "dolt";
        rev = "v${version}";
        sha256 = "1rfwhh62phz75kariqgpkxi4wzll1crzc34x0ybihxllpjf998zx";
    };

    modRoot = "./go";
    subPackages = [ "cmd/dolt" "cmd/git-dolt" "cmd/git-dolt-smudge" ];
  vendorSha256 = "1bq8z31yxff0nybzjs7jz7rg61hgqz6l2scbab7062j8whg8wybb";

  doCheck = false;

    meta = with lib; {
        description = "Relational database with version control and CLI a-la Git.";
        homepage = "https://github.com/liquidata-inc/dolt";
        license = licenses.asl20;
        maintainers = with maintainers; [ danbst ];
        platforms = platforms.linux ++ platforms.darwin;
    };
}
