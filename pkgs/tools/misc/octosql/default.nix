{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "octosql";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner  = "cube2222";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-ysp9DLpAvaZVZBWZAzwUuULtnO++M1/DAiYHR+4/7vA=";
  };

  vendorHash = "sha256-JeVQz6NpekB4boRIxq2JJ3qYHTGj3K3+d5mxSblfvKs=";

  ldflags = [ "-s" "-w" "-X github.com/cube2222/octosql/cmd.VERSION=${version}" ];

  postInstall = ''
    rm -v $out/bin/tester
  '';

  meta = with lib; {
    description = "Commandline tool for joining, analyzing and transforming data from multiple databases and file formats using SQL";
    homepage = "https://github.com/cube2222/octosql";
    license = licenses.mpl20;
    maintainers = with maintainers; [ arikgrahl ];
  };
}
