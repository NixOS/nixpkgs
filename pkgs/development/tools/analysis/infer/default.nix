{ stdenv, fetchFromGitHub,
infer-deps, facebook-clang,
autoconf, automake, cmake, gcc, git, gnum4, ocaml, opam_1_2, openjdk, perl, pkgconfig, python2, sqlite, which, zlib,
withC ? true,
withJava ? true
}:

stdenv.mkDerivation rec {
  pname = "infer";
  version = "0.15.0";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "infer";
    rev = "v${version}";
    sha256 = "1fzm5s0cwah6jk37rrb9dsrfd61f2ird3av0imspyi4qyp6pyrm6";
  };

  facebook-clang-plugins = fetchFromGitHub {
    owner = "facebook";
    repo = "facebook-clang-plugins";
    rev = "f31f7c9c28d8fb9b59c0dacc74a24e4bfe90a904";
    sha256 = "11icpjm73xmyjla9cgg117sn380iibcd3xk743v0z8scwi79aaq8";
  };

  case_fail = ./FailingTest.java;
  case_pass = ./PassingTest.java;

  dontUseCmakeConfigure = true;
  dontBuild = true;
  doCheck = false; # for now, but want to set to true later

  depsBuildBuild = [ git ];

  nativeBuildInputs = [ which ];

  buildInputs = [
    autoconf
    automake
    facebook-clang
    gnum4
    infer-deps
    ocaml
    opam_1_2
    perl
    pkgconfig
    python2
    sqlite
    # TODO - include ocamlPackages.utop v2.1.0 for infer-repl
    zlib
  ]
  # infer will need recent gcc or clang to work properly on linux (custom clang depends on libs)
  #++ stdenv.lib.optionals stdenv.isLinux [ gcc ]
  ++ stdenv.lib.optionals withC [ cmake facebook-clang ]
  ++ stdenv.lib.optionals withJava [ openjdk ]
  ;

  postUnpack = "
    # setup opam stuff
    export OPAMROOT=${infer-deps}/opam
    export OPAM_BACKUP=${infer-deps}/opam.bak
    export OCAML_VERSION='4.06.1+flambda'
    export INFER_OPAM_SWITCH=infer-$OCAML_VERSION

    # dumb hack: some opam operations need to write minor build files to opam repo
    chmod u+w ${infer-deps}
    # backup stays around if previous builds have failed: make sure to nuke it
    [[ -d $OPAM_BACKUP ]] && (chmod -R u+w $OPAM_BACKUP && rm -rf $OPAM_BACKUP)
    cp -r $OPAMROOT $OPAM_BACKUP
    chmod -R u+w $OPAMROOT

    eval $(SHELL=bash opam config env --switch=$INFER_OPAM_SWITCH)

    # link facebook clang plugins and the custom clang itself (bit hacky)
    chmod u+w $src
    rm -rf $src/facebook-clang-plugins
    ln -s ${facebook-clang-plugins} $src/facebook-clang-plugins
    chmod -R u+w $src/facebook-clang-plugins

    pushd $src/facebook-clang-plugins/clang > /dev/null
    [[ -h include ]] && rm include
    [[ -h install ]] && rm install
    ln -s ${facebook-clang} $src/facebook-clang-plugins/clang/install
    ln -s ${facebook-clang}/include $src/facebook-clang-plugins/clang/include
    shasum -a 256 setup.sh src/clang-7.0.tar.xz > installed.version
    popd > /dev/null
  ";

  preConfigure = "./autogen.sh";

  configureFlags = [ "--with-fcp-clang" ]
    ++ stdenv.lib.optionals (!withC) [ "--disable-c-analyzers" ]
    ++ stdenv.lib.optionals (!withJava) [ "--disable-java-analyzers" ]
  ;

  installPhase = "make install";

  postInstall = "
    # restore original opam state
    rm -rf $OPAMROOT
    mv $OPAM_BACKUP $OPAMROOT
  ";

  #checkPhase = ''
  #  #$out/bin/infer --fail-on-issue -- javac ${case_fail}
  #  #$out/bin/infer --fail-on-issue -- javac ${case_pass}
  #'';

  meta = with stdenv.lib; {
    description = "A static analyzer for Java, C, C++, and Objective-C";
    longDescription = ''
        A tool written in OCaml by Facebook for static analysis.
        See homepage or https://github.com/facebook/infer for more information.

        Note: building java analyzers requires downloading some GPL-licensed components.
    '';
    homepage = "https://fbinfer.com";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ amar1729 ];
    platforms = platforms.all;
  };
}
