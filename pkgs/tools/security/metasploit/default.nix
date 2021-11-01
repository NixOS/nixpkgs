{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, ruby
, bundlerEnv
}:

let
  env = bundlerEnv {
    inherit ruby;
    name = "metasploit-bundler-env";
    gemdir = ./.;
  };
in stdenv.mkDerivation rec {
  pname = "metasploit-framework";
  version = "6.1.12";

  src = fetchFromGitHub {
    owner = "rapid7";
    repo = "metasploit-framework";
    rev = version;
    sha256 = "sha256-I7wk8DBN7i4zE4bEIMVGcZi4OMIsbh0Ay2RsAh0VRrw=";
  };

  nativeBuildInputs = [ makeWrapper ];

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

    makeWrapper ${env}/bin/bundle $out/bin/msf-pattern_create \
      --add-flags "exec ${ruby}/bin/ruby $out/share/msf/tools/exploit/pattern_create.rb"

    makeWrapper ${env}/bin/bundle $out/bin/msf-pattern_offset \
      --add-flags "exec ${ruby}/bin/ruby $out/share/msf/tools/exploit/pattern_offset.rb"
  '';

  # run with: nix-shell maintainers/scripts/update.nix --argstr path metasploit
  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Metasploit Framework - a collection of exploits";
    homepage = "https://github.com/rapid7/metasploit-framework/wiki";
    platforms = platforms.unix;
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab makefu ];
    mainProgram = "msfconsole";
  };
}
