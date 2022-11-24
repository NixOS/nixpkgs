{ lib
, buildGoModule
, fetchFromGitLab
, nix
, subversion
, makeWrapper
}:

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

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/wp4nix \
      --prefix PATH : ${lib.makeBinPath [ nix subversion ]}
  '';

  meta = with lib; {
    description = "Packaging helper for Wordpress themes and plugins";
    homepage = "https://git.helsinki.tools/helsinki-systems/wp4nix";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };
}

