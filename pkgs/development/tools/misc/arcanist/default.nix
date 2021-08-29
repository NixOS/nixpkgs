{ bison
, fetchFromGitHub
, flex
, php
, lib, stdenv
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
  buildInputs = [ bison flex php ];

  postPatch = lib.optionalString stdenv.isAarch64 ''
    substituteInPlace support/xhpast/Makefile \
      --replace "-minline-all-stringops" ""
  '';

  buildPhase = ''
    make cleanall -C support/xhpast
    make xhpast -C support/xhpast
  '';

  installPhase = ''
    mkdir -p $out/bin $out/libexec
    make install -C support/xhpast
    make cleanall -C support/xhpast
    cp -R . $out/libexec/arcanist

    ${makeArcWrapper "arc"}
    ${makeArcWrapper "phage"}
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
