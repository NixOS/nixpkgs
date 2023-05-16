{ lib, stdenv, fetchFromGitHub, git, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "ihp-new";
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "digitallyinduced";
    repo = "ihp";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-o0ZSDaDFgwbXqozHfcXKxW4FeF7JqaGprAh6r7NhvhE";
  };

  dontConfigure = true;
  sourceRoot = "${src.name}/ProjectGenerator";
=======
    sha256 = "sha256-LUIC7Olu2qTxZwgkgVpmTgCEQYDlwvLQFQt3Ox/Vm48=";
  };

  dontConfigure = true;
  sourceRoot = "source/ProjectGenerator";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 bin/ihp-new -t $out/bin
    wrapProgram $out/bin/ihp-new \
      --suffix PATH ":" "${lib.makeBinPath [ git ]}";
  '';

  meta = with lib; {
    description = "Project generator for the IHP (Integrated Haskell Platform) web framework";
    homepage = "https://ihp.digitallyinduced.com";
    license = licenses.mit;
    maintainers = [ maintainers.mpscholten ];
    platforms = platforms.unix;
  };
}
