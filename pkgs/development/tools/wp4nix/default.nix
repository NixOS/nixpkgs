{ lib, buildGoModule, fetchFromGitLab, nix, subversion }:

buildGoModule rec {
  pname = "wp4nix";
  version = "1.0.0";

  src = fetchFromGitLab {
    domain = "git.helsinki.tools";
    owner = "helsinki-systems";
    repo = "wp4nix";
    rev = "v${version}";
    sha256 = "sha256-WJteeFUMr684yZEtUP13MqRjJ1UAeo48AzOPdLEE65w=";
  };

  vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

  postPatch = ''
    substituteInPlace main.go --replace nix-hash ${nix}/bin/nix-hash
    substituteInPlace svn.go --replace '"svn"' '"${subversion}/bin/svn"'
  '';

  meta = with lib; {
    description = "Packaging helper for Wordpress themes and plugins";
    homepage = "https://git.helsinki.tools/helsinki-systems/wp4nix";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };
}

