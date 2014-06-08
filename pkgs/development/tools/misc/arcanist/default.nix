{ stdenv, fetchgit, php, makeWrapper }:

let
  libphutil = fetchgit {
    url    = "git://github.com/facebook/libphutil.git";
    rev    = "c4cb6d99c4a5903079350f85fcc71895c0a0ea14";
    sha256 = "a7293aac4fdcfbaead09ee3e6ffb54c5d100b07905b4006194067411061ff994";
  };
  arcanist = fetchgit {
    url    = "git://github.com/facebook/arcanist.git";
    rev    = "50caec620a8ed45c54323cb71fee72fd0d935115";
    sha256 = "dd18ed22375ad1ba058703952be0d339d9c93704e9d75dd7e4e6625236dfe9b0";
  };
in
stdenv.mkDerivation rec {
  name    = "arcanist-${version}";
  version = "20140530";

  src = [ arcanist libphutil ];
  buildInputs = [ php makeWrapper ];

  unpackPhase = "true";
  buildPhase = "true";
  installPhase = ''
    mkdir -p $out/bin $out/libexec
    cp -R ${libphutil} $out/libexec/libphutil
    cp -R ${arcanist}  $out/libexec/arcanist

    ln -s $out/libexec/arcanist/bin/arc $out/bin

    wrapProgram $out/bin/arc \
      --prefix PATH : "${php}/bin"
  '';

  meta = {
    description = "Command line interface to Phabricator";
    homepage    = "http://phabricator.org";
    license     = stdenv.lib.licenses.asl20;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
