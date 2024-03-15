{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "docopts";
  version = "0.6.4-with-no-mangle-double-dash";

  src = fetchFromGitHub {
    owner = "docopt";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GIBrJ5qexeJ6ul5ek9LJZC4J3cNExsTrnxdzRCfoqn8=";
  };

  vendorHash = "sha256-+pMgaHB69itbQ+BDM7/oaJg3HrT1UN+joJL7BO/2vxE=";

  preBuild = ''
    cp ${./go.mod} go.mod
    cp ${./go.sum} go.sum
  '';

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    install -D -m 755 ./docopts.sh $out/bin/docopts.sh
  '';

  meta = with lib; {
    homepage = "https://github.com/docopt/docopts";
    description = "docopt CLI tool for shell scripting";
    license = licenses.mit;
    maintainers = [ maintainers.confus ];
    platforms = platforms.unix;
  };
}
