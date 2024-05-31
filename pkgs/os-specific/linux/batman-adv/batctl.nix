{ lib, stdenv, fetchurl, pkg-config, libnl }:

let cfg = import ./version.nix; in

stdenv.mkDerivation rec {
  pname = "batctl";
  inherit (cfg) version;

  src = fetchurl {
    url = "https://downloads.open-mesh.org/batman/releases/batman-adv-${version}/${pname}-${version}.tar.gz";
    sha256 = cfg.sha256.${pname};
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libnl ];

  preBuild = ''
    makeFlags="PREFIX=$out"
  '';

  meta = {
    homepage = "https://www.open-mesh.org/projects/batman-adv/wiki/Wiki";
    description = "B.A.T.M.A.N. routing protocol in a linux kernel module for layer 2, control tool";
    mainProgram = "batctl";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = with lib.platforms; linux;
  };
}
