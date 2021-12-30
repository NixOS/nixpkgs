{ lib, stdenv, fetchFromGitHub, gnugrep, ncurses, pkg-config, installShellFiles, readline, postgresql, pspg, testVersion }:

stdenv.mkDerivation rec {
  pname = "pspg";
  version = "5.5.1";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = version;
    sha256 = "sha256-EQOIbpP80t/SVwrY/iEYTdfE1L/VmI5VxBrr+mBvICo=";
  };

  nativeBuildInputs = [ pkg-config installShellFiles ];
  buildInputs = [ gnugrep ncurses readline postgresql ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    installShellCompletion --bash --cmd pspg bash-completion.sh
  '';

  passthru.tests.version = testVersion { package = pspg; };

  meta = with lib; {
    homepage = "https://github.com/okbob/pspg";
    description = "Postgres Pager";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.jlesquembre ];
  };
}
