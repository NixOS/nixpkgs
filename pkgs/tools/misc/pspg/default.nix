{ lib, stdenv, fetchFromGitHub, gnugrep, ncurses, pkg-config, installShellFiles, readline, postgresql }:

stdenv.mkDerivation rec {
  pname = "pspg";
  version = "5.8.2";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = version;
    sha256 = "sha256-1mL/UlN7wD0GBYwg0C2eYCB3MtFO2ILd4+A7br+/ovs=";
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
