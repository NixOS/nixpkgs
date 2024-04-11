{ fetchurl, lib, stdenv, autoreconfHook, curl }:

let
  major = "2";
  minor = "22";
in stdenv.mkDerivation rec {
  pname = "dirb";
  version = "${major}.${minor}";

  src = fetchurl {
    url = "mirror://sourceforge/dirb/${version}/dirb${major}${minor}.tar.gz";
    sha256 = "0b7wc2gvgnyp54rxf1n9arn6ymrvdb633v6b3ah138hw4gg8lx7k";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ curl ];

  unpackPhase = ''
    tar -xf $src
    find . -exec chmod +x "{}" ";"
    export sourceRoot="dirb222"
  '';

  postPatch = ''
    sed -i "s#/usr#$out#" src/dirb.c
  '';

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: resume.o:/build/dirb222/src/variables.h:15: multiple definition of `curl';
  #     crea_wordlist.o:/build/dirb222/src/variables.h:15: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  postInstall = ''
    mkdir -p $out/share/{dirb,wordlists}
    cp -r wordlists/ $out/share/dirb/
    ln -s $out/share/dirb/wordlists/ $out/share/wordlists/dirb
  '';

  meta = {
    description = "A web content scanner";
    homepage = "https://dirb.sourceforge.net/";
    maintainers = with lib.maintainers; [ bennofs ];
    license = with lib.licenses; [ gpl2Only ];
    platforms = lib.platforms.unix;
  };
}
