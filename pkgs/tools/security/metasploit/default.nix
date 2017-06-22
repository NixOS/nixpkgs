{ stdenv, fetchFromGitHub, makeWrapper, ruby, bundlerEnv }:

# Maintainer notes for updating:
# 1. increment version number in expression and in Gemfile
# 2. run $ nix-shell --command "bundler install && bundix"
#    in metasploit in nixpkgs

let
  env = bundlerEnv {
    inherit ruby;
    name = "metasploit-bundler-env";
    gemdir = ./.;
  };
in stdenv.mkDerivation rec {
  name = "metasploit-framework-${version}";
  version = "4.14.25";

  src = fetchFromGitHub {
    owner = "rapid7";
    repo = "metasploit-framework";
    rev = version;
    sha256 = "0cp1ybq29a0r7kabg4p2yj0qm90hjvr4xxp0pynb2g406sbyycjm";
  };

  buildInputs = [ makeWrapper ];

  dontPatchelf = true; # stay away from exploit executables

  installPhase = ''
    mkdir -p $out/{bin,share/msf}

    cp -r * $out/share/msf

    for i in $out/share/msf/msf*; do
      bin=$out/bin/$(basename $i)
      cat > $bin <<EOF
#!/bin/sh -e
exec ${env}/bin/bundle exec ${ruby}/bin/ruby $i "\$@"
EOF
      chmod +x $bin
    done
  '';

  meta = with stdenv.lib; {
    description = "Metasploit Framework - a collection of exploits";
    homepage = https://github.com/rapid7/metasploit-framework/wiki;
    platforms = platforms.unix;
    license = licenses.bsd3;
    maintainers = [ maintainers.makefu ];
  };
}
