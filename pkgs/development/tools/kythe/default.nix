{ stdenv, binutils , fetchurl, glibc, ncurses5 }:

stdenv.mkDerivation rec {
  version = "0.0.28";
  name = "kythe-${version}";

  src = fetchurl {
    url = "https://github.com/google/kythe/releases/download/v0.0.28/kythe-v0.0.28.tar.gz";
    sha256 = "1qc7cngpxw66m3krpr5x50ns7gb3bpv2bdfzpb5afl12qp0mi6zm";
  };

  buildInputs =
    [ binutils ];

  doCheck = false;

  dontBuild = true;

  installPhase = ''
    cd tools
    for exe in http_server \
                kythe read_entries triples verifier \
                write_entries write_tables entrystream; do
      echo "Patching:" $exe
      patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $exe
      patchelf --set-rpath "${stdenv.cc.cc.lib}/lib64:${ncurses5}/lib" $exe
    done
    cd ../
    cp -R ./ $out
    ln -s $out/tools $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A pluggable, (mostly) language-agnostic ecosystem for building tools that work with code.";
    longDescription = ''
    The Kythe project was founded to provide and support tools and standards
      that encourage interoperability among programs that manipulate source
      code. At a high level, the main goal of Kythe is to provide a standard,
      language-agnostic interchange mechanism, allowing tools that operate on
      source code — including build systems, compilers, interpreters, static
      analyses, editors, code-review applications, and more — to share
      information with each other smoothly.  '';
    homepage = https://kythe.io/;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.mpickering ];
  };
}
