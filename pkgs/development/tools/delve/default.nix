{ lib, buildGoPackage, fetchFromGitHub, makeWrapper }:

buildGoPackage rec {
  pname = "delve";
  version = "1.7.0";

  goPackagePath = "github.com/go-delve/delve";
  excludedPackages = "\\(_fixtures\\|scripts\\|service/test\\)";

  src = fetchFromGitHub {
    owner = "go-delve";
    repo = "delve";
    rev = "v${version}";
    sha256 = "sha256-RfBDeBuI/Yk24Q2jX/Re7fvx1bhYWJjqLhRkNHCaM9k=";
  };

  subPackages = [ "cmd/dlv" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    # fortify source breaks build since delve compiles with -O0
    wrapProgram $out/bin/dlv \
      --prefix disableHardening " " fortify
  '';

  meta = with lib; {
    description = "debugger for the Go programming language";
    homepage = "https://github.com/derekparker/delve";
    maintainers = with maintainers; [ vdemeester ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ] ++ platforms.darwin;
  };
}
