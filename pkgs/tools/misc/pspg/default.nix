{ lib, stdenv, fetchFromGitHub, gnugrep, ncurses, pkg-config, installShellFiles, readline, postgresql }:

stdenv.mkDerivation rec {
  pname = "pspg";
<<<<<<< HEAD
  version = "5.8.0";
=======
  version = "5.7.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-VkWGVKLN8arc6BOivmjSk8MtMbp2WYqZE9lM8oTQe+U=";
=======
    sha256 = "sha256-ztgvzt+fWPpb2Ero0ruJXGXLTDTbnjsYy9zUoyElqrE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config installShellFiles ];
  buildInputs = [ gnugrep ncurses readline postgresql ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    installManPage pspg.1
    installShellCompletion --bash --cmd pspg bash-completion.sh
  '';

  meta = with lib; {
    homepage = "https://github.com/okbob/pspg";
    description = "Postgres Pager";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.jlesquembre ];
  };
}
