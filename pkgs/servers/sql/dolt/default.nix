{ stdenv, fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
  pname = "dolt";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "liquidata-inc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fdl18lmdg4wcbf017p963rbq9masm0942vhxam9hxvsvpx08i6y";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" "cmd/git-dolt" "cmd/git-dolt-smudge" ];
  vendorSha256 = "1nsfkxq064lhy0kibf7p2x6zbbk2pb0hbph41bwlmbij204wrawh";

  meta = with lib; {
    description = "Relational database with version control and CLI a-la Git.";
    homepage = "https://github.com/liquidata-inc/dolt";
    license = licenses.asl20;
    maintainers = with maintainers; [ danbst ];
    platforms = with platforms; linux ++ darwin;
  };
}