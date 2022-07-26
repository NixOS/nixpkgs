{ pkgs ? import ../../../../. { } }:

# manually run `nix-build ./pkgs/tools/security/tracee/test.nix` to test
pkgs.nixosTest ({
  name = "tracee-test";
  nodes = {
    machine = { config, pkgs, ... }: {
      environment.systemPackages = [
        pkgs.tracee
        # build the go integration tests as a binary
        (pkgs.tracee.overrideAttrs (oa: {
          pname = oa.pname + "-integration";
          patches = oa.patches or [] ++ [
            # skip test that runs `init -q` which is incompatible with systemd init
            ./skip-init-test.patch
            # skip magic_write test that currently fails
            ./skip-magic_write-test.patch
          ];
          # just build the static lib we need for the go test binary
          makeFlags = oa.makeFlags ++ [ "./dist/libbpf/libbpf.a" ];
          postBuild = ''
            # by default the tests are disabled and this is intended to be commented out
            sed -i '/t.Skip("This test requires root privileges")/d' ./tests/integration/integration_test.go
            CGO_CFLAGS="-I$PWD/dist/libbpf" CGO_LDFLAGS="-lelf -lz $PWD/dist/libbpf/libbpf.a" go test -tags ebpf,integration -c -o $GOPATH/tracee-integration ./tests/integration
          '';
          doCheck = false;
          installPhase = ''
            mkdir -p $out/bin
            cp $GOPATH/tracee-integration $out/bin
          '';
          doInstallCheck = false;
        }))
      ];
    };
  };

  testScript = ''
    with subtest("run integration tests"):
      print(machine.succeed('TRC_BIN="$(which tracee-ebpf)" tracee-integration -test.v -test.run "Test_Events"'))
  '';
})
