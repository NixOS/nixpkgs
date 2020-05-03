{ stdenv, fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
    pname = "dolt";
    version = "0.15.2";

    src = fetchFromGitHub {
        owner = "liquidata-inc";
        repo = "dolt";
        rev = "v${version}";
        sha256 = "0av21czfxpwy4y7n9x6hy6m2fliqcazjx7ww0rwm6kdwxipq1xsz";
    };

    modRoot = "./go";
    subPackages = [ "cmd/dolt" "cmd/git-dolt" "cmd/git-dolt-smudge" ];
    modSha256 = "0c120gkkswg0cqvvhjkxvalr4fsjv81khwg0x0fm8fr6lipkfksn";

    meta = with lib; {
        description = "Relational database with version control and CLI a-la Git.";
        homepage = "https://github.com/liquidata-inc/dolt";
        license = licenses.asl20;
        maintainers = with maintainers; [ danbst ];
        platforms = platforms.linux ++ platforms.darwin;
    };
}
