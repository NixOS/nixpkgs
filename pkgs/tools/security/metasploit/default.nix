{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  ruby,
  bundlerEnv,
  testers,
  python3,
}:

let
  env = bundlerEnv {
    inherit ruby;
    name = "metasploit-bundler-env";
    gemdir = ./.;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "metasploit-framework";
  version = "6.4.106";

  src = fetchFromGitHub {
    owner = "rapid7";
    repo = "metasploit-framework";
    tag = finalAttrs.version;
    hash = "sha256-FpSx6CuVa2fOCoJesQcK+Nft+6k8iPDKyGvTec8TMbo=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    (python3.withPackages (ps: [ ps.requests ]))
  ];

  dontPatchELF = true; # stay away from exploit executables

  postPatch = ''
    # Patch the boot script to disable bootsnap.
    # Bootsnap tries to write cache files to the frozen /nix/store, causing a crash on startup.
    sed -i '/bootsnap\/setup/d' config/boot.rb

    # Remove the strict version check for ActionView.
    # Metasploit upstream enforces a specific patch version (e.g., 7.2.2.2), but our bundler
    # environment may resolve to a newer, compatible version (e.g., 7.2.3), causing the app to raise an exception.
    sed -i "/ActionView::VERSION::STRING == /d" config/application.rb
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/msf}

    cp -r * $out/share/msf

    grep -rl "^#\!.*python2$" $out/share/msf | xargs -d '\n' rm

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

    runHook postInstall
  '';

  passthru.tests = {
    msfconsole-version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "HOME=/tmp msfconsole -q -x 'version;exit'";
    };
  };

  # run with: nix-shell maintainers/scripts/update.nix --argstr path metasploit
  passthru.updateScript = ./update.sh;

  meta = {
    description = "Metasploit Framework - a collection of exploits";
    homepage = "https://docs.metasploit.com/";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      fab
      makefu
      Misaka13514
    ];
    mainProgram = "msfconsole";
  };
})
