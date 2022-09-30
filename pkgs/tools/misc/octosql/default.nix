{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "octosql";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner  = "cube2222";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-qeF34GBR/OtvWBN5mcLMJGzOI/3DzbScJVM0pvlTvyw=";
  };

  vendorSha256 = "sha256-ukNjLk1tTdw0bwXaYAEDuHfzxHuAX1xyqRqC6wmW/H4=";

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
