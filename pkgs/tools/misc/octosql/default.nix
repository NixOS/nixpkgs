{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "octosql";
<<<<<<< HEAD
  version = "0.12.2";
=======
  version = "0.12.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner  = "cube2222";
    repo   = pname;
    rev    = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-jf40w5QkSTAgGu0JA4NeqsasN2TUf9vnKVw5zlZr8Mw=";
  };

  vendorHash = "sha256-p/2UsvxxywQKtk/9wDa5fjS0z6xLLzDONuQ5AtnUonk=";
=======
    sha256 = "sha256-ysp9DLpAvaZVZBWZAzwUuULtnO++M1/DAiYHR+4/7vA=";
  };

  vendorHash = "sha256-JeVQz6NpekB4boRIxq2JJ3qYHTGj3K3+d5mxSblfvKs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
