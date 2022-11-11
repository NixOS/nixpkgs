{ stdenv, lib, python3, fetchFromGitHub, which, coreutils
, perl, installShellFiles
, doCheck ? true
}: stdenv.mkDerivation rec {

  pname = "redo-apenwarr";
  version = "0.42d";

  src = fetchFromGitHub rec {
    owner = "apenwarr";
    repo = "redo";
    rev = "${repo}-${version}";
    sha256 = "/QIMXpVhVLAIJa3LiOlRKzbUztIWZygkWZUKN4Nrh+M=";
  };

  postPatch = ''

    patchShebangs minimal/do

  '' + lib.optionalString doCheck ''
    unset CC CXX

    substituteInPlace minimal/do.test \
      --replace "/bin/pwd" "${coreutils}/bin/pwd"

    substituteInPlace t/105-sympath/all.do \
      --replace "/bin/pwd" "${coreutils}/bin/pwd"

    substituteInPlace t/all.do \
      --replace "/bin/ls" "ls"

    substituteInPlace t/110-compile/hello.o.do \
      --replace "/usr/include" "${lib.getDev stdenv.cc.libc}/include"

    substituteInPlace t/200-shell/nonshelltest.do \
      --replace "/usr/bin/env perl" "${perl}/bin/perl"

  '';

  inherit doCheck;

  checkTarget = "test";

  outputs = [ "out" "man" ];

  installFlags = [
    "PREFIX=$(out)"
    "DESTDIR=/"
  ];

  nativeBuildInputs = [
    python3
    (with python3.pkgs; [ beautifulsoup4 markdown ])
    which
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --bash contrib/bash_completion.d/redo
  '';

  meta = with lib; {
    description = "Smaller, easier, more powerful, and more reliable than make. An implementation of djb's redo";
    homepage = "https://github.com/apenwarr/redo";
    maintainers = with maintainers; [
      andrewchambers
      ck3d
    ];
    license = licenses.asl20;
    platforms = python3.meta.platforms;
  };
}
