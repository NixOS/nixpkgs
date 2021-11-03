{ lib, stdenv, fetchFromGitHub, gnugrep, ncurses, pkg-config, installShellFiles, readline, postgresql }:

stdenv.mkDerivation rec {
  pname = "pspg";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = version;
    sha256 = "sha256-zrnmhv+dc2Om1FE5TeoYCOjKGs2+mfMqcaRaTakHxAQ=";
  };

  nativeBuildInputs = [ pkg-config installShellFiles ];
  buildInputs = [ gnugrep ncurses readline postgresql ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
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
