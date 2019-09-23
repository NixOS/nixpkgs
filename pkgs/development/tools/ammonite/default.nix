{ stdenv, fetchurl, jre
, disableRemoteLogging ? true
}:

with stdenv.lib;

let
common = { scalaVersion, sha256 }:
stdenv.mkDerivation rec {
  pname = "ammonite";
  version = "1.7.1";

  src = fetchurl {
    url = "https://github.com/lihaoyi/Ammonite/releases/download/${version}/${scalaVersion}-${version}";
    inherit sha256;
  };

  phases = "installPhase";

  installPhase = ''
    install -Dm755 ${src} $out/bin/amm
    sed -i '0,/java/{s|java|${jre}/bin/java|}' $out/bin/amm
  '' + optionalString (disableRemoteLogging) ''
    sed -i '0,/ammonite.Main/{s|ammonite.Main|ammonite.Main --no-remote-logging|}' $out/bin/amm
  '';

  meta = {
    description = "Improved Scala REPL";
    longDescription = ''
        The Ammonite-REPL is an improved Scala REPL, re-implemented from first principles.
        It is much more featureful than the default REPL and comes
        with a lot of ergonomic improvements and configurability
        that may be familiar to people coming from IDEs or other REPLs such as IPython or Zsh.
    '';
    homepage = http://www.lihaoyi.com/Ammonite/;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.nequissimus ];
  };
};
in {
  ammonite_2_12 = common { scalaVersion = "2.12"; sha256 = "0isg9flnzc2ldbx6q0lg0xyg9lnvqkd8qhgfln8p1hbzdq0n6jd0"; };
  ammonite_2_13 = common { scalaVersion = "2.13"; sha256 = "01dyc6bilhcr1mwrpmhjc8nhzfqgjh44bx36gd3gk9mkvlbys5mp"; };
}
