{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "octosql";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner  = "cube2222";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-UXHNA53ipGybYYAu+Ml8tI+9YZPW18BLsVjkW/UNQag=";
  };

  vendorSha256 = "sha256-as8vJmUH0mDPQ8K6D5yRybPV5ibvHEtyQjArXjimGpo=";

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
