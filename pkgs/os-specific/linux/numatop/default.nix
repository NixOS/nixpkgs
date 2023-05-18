{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkg-config, numactl, ncurses, check }:

stdenv.mkDerivation rec {
  pname = "numatop";
  version = "2.2";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "numatop";
    rev = "v${version}";
    sha256 = "sha256-GJvTwqgx34ZW10eIJj/xiKe3ZkAfs7GlJImz8jrnjfI=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ numactl ncurses ];
  nativeCheckInputs = [ check ];

  patches = [
    (fetchpatch {
      url = "https://github.com/intel/numatop/pull/54.patch";
      sha256 = "sha256-TbMLv7TT9T8wE4uJ1a/AroyPPwrwL0eX5IBLsh9GTTM=";
      name = "fix-string-operations.patch";
    })
    (fetchpatch {
      url = "https://github.com/intel/numatop/pull/64.patch";
      sha256 = "sha256-IevbSFJRTS5iQ5apHOVXzF67f3LJaW6j7DySFmVuyiM=";
      name = "fix-format-strings-mvwprintw.patch";
    })
  ];

  doCheck  = true;

  meta = with lib; {
    description = "Tool for runtime memory locality characterization and analysis of processes and threads on a NUMA system";
    homepage = "https://01.org/numatop";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dtzWill ];
    platforms = [
      "i686-linux" "x86_64-linux"
      "powerpc64-linux" "powerpc64le-linux"
    ];
  };
}
