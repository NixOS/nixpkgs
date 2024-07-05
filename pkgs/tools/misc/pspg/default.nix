{ lib, stdenv, fetchFromGitHub, gnugrep, ncurses, pkg-config, installShellFiles, readline, postgresql }:

stdenv.mkDerivation rec {
  pname = "pspg";
  version = "5.8.6";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = version;
    sha256 = "sha256-UgJHsniDbfAcohnrYYUUJ4OhL2Fr65kGu26dsw9vYyM=";
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
    mainProgram = "pspg";
  };
}
