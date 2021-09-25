{ bison
, fetchFromGitHub
, flex
, php
, lib, stdenv
, installShellFiles
}:

# Make a custom wrapper. If `wrapProgram` is used, arcanist thinks .arc-wrapped is being
# invoked and complains about it being an unknown toolset. We could use `makeWrapper`, but
# then we’d need to still craft a script that does the `php libexec/arcanist/bin/...` dance
# anyway... So just do everything at once.
let makeArcWrapper = toolset: ''
  cat << WRAPPER > $out/bin/${toolset}
  #!$shell -e
  export PATH='${php}/bin/'\''${PATH:+':'}\$PATH
  exec ${php}/bin/php $out/libexec/arcanist/bin/${toolset} "\$@"
  WRAPPER
  chmod +x $out/bin/${toolset}
'';

in
stdenv.mkDerivation {
  pname = "arcanist";
  version = "20200711";

  src = fetchFromGitHub {
    owner = "phacility";
    repo = "arcanist";
    rev = "2565cc7b4d1dbce6bc7a5b3c4e72ae94be4712fe";
    sha256 = "0jiv4aj4m5750dqw9r8hizjkwiyxk4cg4grkr63sllsa2dpiibxw";
  };

  buildInputs = [ php ];

  nativeBuildInputs = [ bison flex installShellFiles ];

  postPatch = lib.optionalString stdenv.isAarch64 ''
    substituteInPlace support/xhpast/Makefile \
      --replace "-minline-all-stringops" ""
  '';

  buildPhase = ''
    runHook preBuild
    make cleanall -C support/xhpast $makeFlags "''${makeFlagsArray[@]}" -j $NIX_BUILD_CORES
    make xhpast   -C support/xhpast $makeFlags "''${makeFlagsArray[@]}" -j $NIX_BUILD_CORES
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/libexec
    make install  -C support/xhpast $makeFlags "''${makeFlagsArray[@]}" -j $NIX_BUILD_CORES
    make cleanall -C support/xhpast $makeFlags "''${makeFlagsArray[@]}" -j $NIX_BUILD_CORES
    cp -R . $out/libexec/arcanist

    ${makeArcWrapper "arc"}
    ${makeArcWrapper "phage"}

    $out/bin/arc shell-complete --generate --
    installShellCompletion --cmd arc --bash $out/libexec/arcanist/support/shell/rules/bash-rules.sh
    installShellCompletion --cmd phage --bash $out/libexec/arcanist/support/shell/rules/bash-rules.sh
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/arc help diff -- > /dev/null
    $out/bin/phage help alias -- > /dev/null
  '';

  meta = {
    description = "Command line interface to Phabricator";
    homepage = "http://phabricator.org";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
