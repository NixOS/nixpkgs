{ stdenv, lib, python27, fetchFromGitHub, mkdocs, which, findutils, coreutils
, perl
, doCheck ? true
}: let

  # copy from 
  # pkgs/applications/networking/pyload/beautifulsoup.nix
  beautifulsoup = python27.pkgs.callPackage ./beautifulsoup.nix {
    pythonPackages = python27.pkgs;
  };

  mkdocs-exclude = python27.pkgs.callPackage ./mkdocs-exclude.nix {
    pythonPackages = python27.pkgs;
  };
in stdenv.mkDerivation rec {

  pname = "redo-apenwarr";
  version = "0.42";

  src = fetchFromGitHub {
    owner = "apenwarr";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1060yb7hrxm8c7bfvb0y4j0acpxsj6hbykw1d9549zpkxxr9nsgm";
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
      --replace "/usr/include" "${stdenv.lib.getDev stdenv.cc.libc}/include"

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
    python27
    beautifulsoup
    mkdocs
    mkdocs-exclude
    which
    findutils
  ];

  meta = with lib; {
    description = "Smaller, easier, more powerful, and more reliable than make. An implementation of djb's redo.";
    homepage = https://github.com/apenwarr/redo;
    maintainers = with maintainers; [
      andrewchambers
      ck3d
    ];
    license = licenses.asl20;
  };
}
