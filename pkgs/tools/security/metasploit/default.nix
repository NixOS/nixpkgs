{ stdenv, fetchFromGitHub, makeWrapper, ruby, bundlerEnv }:

# Maintainer notes for updating:
# 1. increment version number in expression and in Gemfile
# 2. run $ nix-shell --command "bundler install && bundix"
#    in metasploit in nixpkgs
# 3. run $ sed -i '/[ ]*dependencies =/d' gemset.nix
# 4. run $ nix-build -A metasploit ../../../../
# 5. update sha256sum in expression
# 6. run step 3 again

let
  env = bundlerEnv {
    inherit ruby;
    name = "metasploit-bundler-env";
    gemdir = ./.;
  };
in stdenv.mkDerivation rec {
  pname = "metasploit-framework";
  version = "5.0.74";

  src = fetchFromGitHub {
    owner = "rapid7";
    repo = "metasploit-framework";
    rev = version;
    sha256 = "1ml4d6xfaxyv1mamc2qldd39db92qkic8660f8clabi9f1k0ghpp";
  };

  buildInputs = [ makeWrapper ];

  dontPatchELF = true; # stay away from exploit executables

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
