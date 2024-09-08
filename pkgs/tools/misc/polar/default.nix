{ lib, stdenv, fetchFromGitHub, ruby, bundlerEnv }:
let

  # To create Gemfile.lock and gemset.nix
  # > nix-shell -p bundix bundler zlib
  # > bundle install
  # > bundix
  gems = bundlerEnv {
    name = "polar-env";
    inherit ruby;
    gemdir = ./.;
  };

in
stdenv.mkDerivation rec {

  pname = "polar";
  # The package has no releases so let's use the latest commit
  version = "unstable-2021-01-12";

  src = fetchFromGitHub {
    owner = "cmaion";
    repo = pname;
    rev = "be15f5f897f8a919dd639009873147dca2a9cea0";
    sha256 = "0gqkqfrqnrsy6avg372xwqj22yz8g6r2hnzbw6197b1rf7zr1il7";
  };

  prePatch = ''
    for script in polar_*
    do
      substituteInPlace $script --replace "#{File.dirname(__FILE__)}/lib" "$out/lib/polar"
    done
  '';
  buildInputs = [ gems ruby ];

  # See: https://wiki.nixos.org/wiki/Packaging/Ruby
  #
  # Put library content under lib/polar and the raw scripts under share/polar.
  # Then, wrap the scripts so that they use the correct ruby environment and put
  # these wrapped executables under bin.
  installPhase = ''
    install -Dm644 -t $out/etc/udev/rules.d ./pkg/99-polar.rules
    mkdir -p $out/{bin,lib/polar,share/polar}
    cp -r lib/* $out/lib/polar/
    for script in ./polar_*
    do
      raw="$out/share/polar/$script"
      bin="$out/bin/$script"
      cp "$script" "$raw"
      cat > $bin <<EOF
#!/bin/sh -e
exec ${gems}/bin/bundle exec ${ruby}/bin/ruby "$raw" "\$@"
EOF
      chmod +x $bin
    done
  '';

  meta = with lib; {
    description = "Command-line tools to interact with Polar watches";
    longDescription = ''
      A set of command line tools written in Ruby to interact with Polar watches
      and decode raw data files.

      Udev rules can be added as:

        services.udev.packages = [ pkgs.polar ]
    '';
    homepage = "https://github.com/cmaion/polar";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jluttine ];
    platforms = platforms.linux;
  };
}
