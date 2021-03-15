{ stdenv, fetchurl, which }:

let base = version: sha512: stdenv.mkDerivation rec {
  pname = "lowdown";
  inherit version;

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${version}.tar.gz";
    inherit sha512;
  };

  nativeBuildInputs = [ which ];

  configurePhase = ''
    ./configure PREFIX=''${!outputDev} \
                BINDIR=''${!outputBin}/bin \
                MANDIR=''${!outputBin}/share/man
  '';

  meta = with stdenv.lib; {
    homepage = "https://kristaps.bsd.lv/lowdown/";
    description = "Simple markdown translator";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.unix;
  };
};
in {
  lowdown = base "0.7.3" "14mx22aqr9cmin4cyhrclhm0hly1i21j2dmsikfp1c87wl2kpn9xgxnix5r0iqh5dwjxdh591rfh21xjp0l11m0nl5wkpnn7wmq7g6b";
  lowdown_0_8 = base "0.8.2" "07xy6yjs24zkwrr06ly4ln5czvm3azw6iznx6m8gbrmzblkcp3gz1jcl9wclcyl8bs4xhgmyzkf5k67b95s0jndhyb9ap5zy6ixnias";
}

