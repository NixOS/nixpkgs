{ buildGoModule, fetchFromGitHub, stdenv }:

let
  pname = "dapr";
  version = "0.9.0";
  sha256 = "1vdbh5pg3j7kqqqhhf4d9xfzbpqmjc4x373sk43pb05prg4w71s7";
  vendorSha256 = "19qcpd5i60xmsr8m8mx16imm5falkqcgqpwpx3clfvqxjyflglpp";
in buildGoModule {
  inherit pname version vendorSha256;

  src = fetchFromGitHub {
    inherit sha256;

    owner = "dapr";
    repo = "cli";
    rev = "v${version}";
  };

  doCheck = false;

  postInstall = ''
    mv $out/bin/cli $out/bin/dapr
  '';

  meta = with stdenv.lib; {
    homepage = "https://dapr.io";
    description = "A CLI for managing Dapr, the distributed application runtime";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
