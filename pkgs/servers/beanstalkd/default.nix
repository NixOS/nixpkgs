{ lib, stdenv, fetchFromGitHub, installShellFiles, nixosTests }:

stdenv.mkDerivation rec {
  version = "1.12";
  pname = "beanstalkd";

  src = fetchFromGitHub {
    owner = "kr";
    repo = "beanstalkd";
    rev = "v${version}";
    hash = "sha256-HChpVZ02l08CObrb4+ZEjBiXeQMMYi6zhSWUTDxuEao=";
  };

  hardeningDisable = [ "fortify" ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage doc/beanstalkd.1
  '';

  passthru.tests = {
    smoke-test = nixosTests.beanstalkd;
  };

  meta = with lib; {
    homepage = "http://kr.github.io/beanstalkd/";
    description = "A simple, fast work queue";
    license = licenses.mit;
    maintainers = [ maintainers.zimbatm ];
    platforms = platforms.all;
  };
}
