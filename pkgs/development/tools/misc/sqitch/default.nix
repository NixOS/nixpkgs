{ stdenv, writeScript, makeWrapper, sqitchModule }:
stdenv.mkDerivation rec {
  name = "sqitch-0.999";
  buildInputs = [ makeWrapper ];
  builder = writeScript (name + "-builder.sh") ''
    . ${stdenv}/setup
    mkdir -p $out/bin
    for d in bin/sqitch etc lib share ; do
      ln -s ${sqitchModule}/$d $out/$d
    done
    fixupPhase
    wrapProgram $out/bin/sqitch \
      --prefix PERL5LIB : \
      "$(for i in $(cat ${sqitchModule}/nix-support/propagated-native-build-inputs) ; do
           echo -n "$i"/lib/perl5/site_perl:
         done
         echo ${sqitchModule}/lib/perl5/site_perl
        )"
  '';
}
