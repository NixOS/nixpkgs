{ stdenv, fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
    pname = "dolt";
    version = "0.18.2";

    src = fetchFromGitHub {
        owner = "liquidata-inc";
        repo = "dolt";
        rev = "v${version}";
        sha256 = "054dy5n9b8ahfwsih4chqg83c5sp8ihc68y79kz4508d42r0zvxz";
    };

    modRoot = "./go";
    subPackages = [ "cmd/dolt" "cmd/git-dolt" "cmd/git-dolt-smudge" ];
  vendorSha256 = "1dp1asi4iz9j0m8bqiap7m6ph0qf2bi9j2yn6q53539qspc5gkr2";

  doCheck = false;

    meta = with lib; {
        description = "Relational database with version control and CLI a-la Git.";
        homepage = "https://github.com/liquidata-inc/dolt";
        license = licenses.asl20;
        maintainers = with maintainers; [ danbst ];
        platforms = platforms.linux ++ platforms.darwin;
    };
}
