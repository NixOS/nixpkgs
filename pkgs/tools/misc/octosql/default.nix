{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "octosql";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner  = "cube2222";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-jf40w5QkSTAgGu0JA4NeqsasN2TUf9vnKVw5zlZr8Mw=";
  };

  vendorHash = "sha256-p/2UsvxxywQKtk/9wDa5fjS0z6xLLzDONuQ5AtnUonk=";

  ldflags = [ "-s" "-w" "-X github.com/cube2222/octosql/cmd.VERSION=${version}" ];

  postInstall = ''
    rm -v $out/bin/tester
  '';

  meta = with lib; {
    description = "Commandline tool for joining, analyzing and transforming data from multiple databases and file formats using SQL";
    homepage = "https://github.com/cube2222/octosql";
    license = licenses.mpl20;
    maintainers = with maintainers; [ arikgrahl ];
    mainProgram = "octosql";
  };
}
