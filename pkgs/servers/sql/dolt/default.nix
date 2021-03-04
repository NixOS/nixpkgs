{ fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
    pname = "dolt";
    version = "0.23.9";

    src = fetchFromGitHub {
        owner = "liquidata-inc";
        repo = "dolt";
        rev = "v${version}";
        sha256 = "sha256-fVU3eOhog34fLnfNQ6mWB7yUEkinm74SgpxYXB9MV/g=";
    };

    modRoot = "./go";
    subPackages = [ "cmd/dolt" "cmd/git-dolt" "cmd/git-dolt-smudge" ];
  vendorSha256 = "sha256-Poumvh7DccY8qCZ5ehFFaqEsL945BxNXFfevJvRawUA=";

  doCheck = false;

    meta = with lib; {
        description = "Relational database with version control and CLI a-la Git";
        homepage = "https://github.com/liquidata-inc/dolt";
        license = licenses.asl20;
        maintainers = with maintainers; [ danbst ];
        platforms = platforms.linux ++ platforms.darwin;
    };
}
