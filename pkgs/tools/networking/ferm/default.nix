{ lib, stdenv, fetchurl, makeWrapper, perl, iptables, nixosTests }:

let
  inherit (lib.versions) majorMinor;
in stdenv.mkDerivation rec {
  version = "2.7";
  pname = "ferm";

  src = fetchurl {
    url = "http://ferm.foo-projects.org/download/${majorMinor version}/ferm-${version}.tar.xz";
    sha256 = "sha256-wA2RDVOU5pZ1YI617g9QTVz9pB6ZCi2akbqsbfk+P5I=";
  };

  # perl is used at build time to gather the ferm version.
  nativeBuildInputs = [ makeWrapper perl ];
  buildInputs = [ perl ];

  makeFlags = [
    "PERL=perl"
    "PREFIX=${placeholder "out"}"
  ];

  postInstall = ''
    rm -r $out/lib/systemd
    for i in "$out/sbin/"*; do
      wrapProgram "$i" --prefix PATH : "${lib.makeBinPath [ iptables ]}"
    done
  '';

  passthru.tests.ferm = nixosTests.ferm;

  meta = {
    homepage = "http://ferm.foo-projects.org/";
    description = "Tool to maintain complex firewalls";
    longDescription = ''
      ferm is a tool to maintain complex firewalls, without having the trouble to
      rewrite the complex rules over and over again. ferm allows the entire
      firewall rule set to be stored in a separate file, and to be loaded with one
      command. The firewall configuration resembles structured programming-like
      language, which can contain levels and lists.
    '';
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [mic92];
    platforms = lib.platforms.linux;
  };
}
