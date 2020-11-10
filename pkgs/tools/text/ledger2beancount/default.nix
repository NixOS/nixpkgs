{ stdenv, fetchFromGitHub, makeWrapper, perlPackages, beancount }:

with stdenv.lib;

let
  perlDeps = with perlPackages; [
    ConfigOnion DateCalc
    FileBaseDir YAMLLibYAML
    GetoptLongDescriptive DateTimeFormatStrptime
    StringInterpolate
  ];

in stdenv.mkDerivation rec {
  pname = "ledger2beancount";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "zacchiro";
    repo = "ledger2beancount";
    rev = version;
    sha256 = "0w88jb1x0w02jwwf6ipx3cxr89kzffrrdqws3556zrvvs01bh84j";
  };

  phases = [
    "unpackPhase"
    "installPhase"
    "fixupPhase"
  ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perlPackages.perl beancount ] ++ perlDeps;

  makeFlags = [ "prefix=$(out)" ];
  installFlags = [ "INSTALL=install" ];

  installPhase = ''
    mkdir -p $out
    cp -r $src/bin $out/bin
  '';

  postFixup = ''
    wrapProgram "$out/bin/ledger2beancount" \
      --set PERL5LIB "${perlPackages.makeFullPerlPath perlDeps}"
  '';

  meta = {
    description = "Ledger to Beancount text-based converter";
    longDescription = ''
      A script to automatically convert Ledger-based textual ledgers to Beancount ones.

      Conversion is based on (concrete) syntax, so that information that is not meaningful for accounting reasons but still valuable (e.g., comments, formatting, etc.) can be preserved.
    '';
    homepage = "https://github.com/zacchiro/ledger2beancount";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pablovsky ];
  };
}
