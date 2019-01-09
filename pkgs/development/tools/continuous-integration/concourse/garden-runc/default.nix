{
  callPackage,
  clang,
  fetchgit,
  go,
  go-bindata,
  iptables,
  runCommand,
  runc,
  stdenv,

  extractDir ? "/tmp/gdn-assets",
}:

let
  version = "1.17.1";

  garden_src = fetchgit {
    rev = "v${version}";
    url = "https://github.com/cloudfoundry/garden-runc-release.git";
    sha256 = "0rzyqg9c3mdn6cz54716izgqdsdjv8h1xlvsx1sq21dcq9jj5ia0";
    fetchSubmodules = true;
  };

  nstar = callPackage ./nstar.nix { inherit garden_src; };
  init = callPackage ./init.nix { inherit garden_src; };
  grootfs = callPackage ./grootfs/default.nix {};

  gdn =
    stdenv.mkDerivation rec {
      name = "garden-runc";
      version = "0.0.1";
      src = garden_src;

      nativeBuildInputs = [ clang go-bindata go ];
      buildInputs = [ init nstar runc iptables ];
      goPackagePath = "code.cloudfoundry.org/guardian";
      buildFlags = [ "-tags daemon" ];
      dontInstall = true;

      preBuild = ''
        LINUX_ASSETS=$PWD/linux
        mkdir -p $LINUX_ASSETS/bin
        mkdir -p $LINUX_ASSETS/sbin
        export GOPATH=$GOPATH:$PWD

        go install code.cloudfoundry.org/guardian/cmd/dadoo
        cp bin/dadoo "$LINUX_ASSETS/bin"

        cp -aL ${iptables}/bin/iptables $LINUX_ASSETS/sbin
        cp -aL ${iptables}/bin/iptables-restore $LINUX_ASSETS/sbin

        cp ${grootfs}/bin/* $LINUX_ASSETS/bin
        cp ${init}/bin/* $LINUX_ASSETS/bin
        cp ${nstar}/bin/* $LINUX_ASSETS/bin
        cp ${runc}/bin/* $LINUX_ASSETS/bin

        go-bindata -nomemcopy -pkg bindata -o src/code.cloudfoundry.org/guardian/bindata/bindata.go linux/...
        go build -tags daemon -o $out/bin/gdn code.cloudfoundry.org/guardian/cmd/gdn

        cp -r $LINUX_ASSETS/. $out/assets
      '';
    };
in
runCommand "wrapped-garden-runc" {
  inherit extractDir;
  passthru = { inherit gdn; };

  meta = {
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ edude03 dxf ];
  };
} ''
  mkdir -p $out/bin
  cat >$out/bin/gdn <<EOF
  #!${stdenv.shell} -e
  exec ${gdn}/bin/gdn "\$@" --assets-dir=$extractDir
  EOF
  chmod +x $out/bin/gdn
''
