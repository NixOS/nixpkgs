{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "nsjail-git-2015-08-10";

  src = fetchgit {
    url = https://github.com/google/nsjail;
    rev = "8b951e6c2827386786cde4a124cd1846d25b9404";
    sha256 = "b3b863423cc676111d2d1afbac524eee6fa824588cafccb7c42ff470508a13b1";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp nsjail $out/bin
  '';

  meta = {
    description = ''
      A light-weight process isolation tool, making use of Linux namespaces
      and seccomp-bpf syscall filters
      '';
    homepage = http://google.github.io/nsjail;

    license = stdenv.lib.licenses.apsl20;

    maintainers = [ stdenv.lib.maintainers.bosu ];

    platforms = stdenv.lib.platforms.linux;
  };
}
