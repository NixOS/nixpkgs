{ stdenv, fetchFromGitHub, makeWrapper, ruby, bundlerEnv }:

# Maintainer notes for updating:
# 1. update version number and revision in expression and in Gemfile
# 2. run $ nix-prefetch-git --url https://github.com/rapid7/metasploit-framework.git --rev [version]
#    in metasploit in nixpkgs, and copy the resulting hash to default.nix
# 3. run $ nix-shell --command "bundler install && bundix"
#    in metasploit in nixpkgs
# 4. run $ nix-build -A metasploit ../../../../

let
  env = bundlerEnv {
    inherit ruby;
    name = "metasploit-bundler-env";
    gemdir = ./.;
  };
in stdenv.mkDerivation rec {
  name = "metasploit-framework-${version}";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "rapid7";
    repo = "metasploit-framework";
    rev = "bf949b7fd2a705a74ca02f66792f80ab41b4c81a";
    sha256 = "1pqh1ya3c3l0jmqzbglyigag1g29yvqp9i8lzlgvcr8wvdf356bv";
  };

  buildInputs = [ makeWrapper ];

  dontPatchelf = true; # stay away from exploit executables

  installPhase = ''
    mkdir -p $out/{bin,share/msf}

    cp -r * $out/share/msf

    (
      cd $out/share/msf/
      for i in msf*; do
        makeWrapper ${env}/bin/bundle $out/bin/$i \
          --add-flags "exec ${ruby}/bin/ruby $out/share/msf/$i"
      done
    )

  '';

  meta = with stdenv.lib; {
    description = "Metasploit Framework - a collection of exploits";
    homepage = https://github.com/rapid7/metasploit-framework/wiki;
    platforms = platforms.unix;
    license = licenses.bsd3;
    maintainers = [ maintainers.makefu ];
  };
}
