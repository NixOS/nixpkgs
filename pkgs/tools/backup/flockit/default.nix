{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "flockit-${version}";
  version = "2012-08-11";

  src = fetchFromGitHub {
    owner  = "smerritt";
    repo   = "flockit";
    rev    = "5c2b2092f8edcc8e3e2eb6ef66c968675dbfa686";
    sha256 = "0vajck9q2677gpn9a4flkyz7mw69ql1647cjwqh834nrcr2b5164";
  };

  installPhase = ''
    mkdir -p $out/lib $out/bin
    cp ./libflockit.so $out/lib

    (cat <<EOI
    #!${stdenv.shell}
    env LD_PRELOAD="$out/lib/libflockit.so" FLOCKIT_FILE_PREFIX=\$1 \''${@:2}
    EOI
    ) > $out/bin/flockit
    chmod +x $out/bin/flockit
  '';

  meta = with stdenv.lib; {
    description = "LD_PRELOAD shim to add file locking to programs that don't do it (I'm looking at you, rsync!)";
    longDescription = ''
      This library and tool exists solely because rsync doesn't have file locking.

      It's not used like a normal library; you don't link against it, and you
      don't have to patch your source code to use it. It's inserted between your
      program and its libraries by use of LD_PRELOAD.

      For example:

        $ env LD_PRELOAD=$(nix-build -A pkgs.flockit)/lib/libflockit.so FLOCKIT_FILE_PREFIX=test rsync SRC DEST

      Besides the library a handy executable is provided which can simplify the above to:

        $ $(nix-build -A pkgs.flockit)/bin/flockit test rsync SRC DEST

      Also see the following blog post:
      https://www.swiftstack.com/blog/2012/08/15/old-school-monkeypatching/
    '';
    homepage = https://github.com/smerritt/flockit;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.basvandijk ];
  };
}
