{ lib, stdenv, buildPackages, fetchFromGitHub, openssl, lzo, zlib, iproute2, ronn }:

stdenv.mkDerivation rec {
  pname = "zerotierone";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "ZeroTierOne";
    rev = version;
    sha256 = "sha256-nr5qvo/SLzQ16B/83lCzlQ5zduPGxOhfqWat/Grsf/Q=";
  };

  preConfigure = ''
    patchShebangs ./doc/build.sh
    substituteInPlace ./doc/build.sh \
      --replace '/usr/bin/ronn' '${buildPackages.ronn}/bin/ronn' \

    substituteInPlace ./make-linux.mk \
      --replace 'armv5' 'armv6'
  '';


  nativeBuildInputs = [ ronn ];
  buildInputs = [ openssl lzo zlib iproute2 ];

  enableParallelBuilding = true;

  buildFlags = [ "all" "selftest" ];

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  checkPhase = ''
    ./zerotier-selftest
  '';

  installPhase = ''
    install -Dt "$out/bin/" zerotier-one
    ln -s $out/bin/zerotier-one $out/bin/zerotier-idtool
    ln -s $out/bin/zerotier-one $out/bin/zerotier-cli

    mkdir -p $man/share/man/man8
    for cmd in zerotier-one.8 zerotier-cli.1 zerotier-idtool.1; do
      cat doc/$cmd | gzip -9n > $man/share/man/man8/$cmd.gz
    done
  '';

  outputs = [ "out" "man" ];

  meta = with lib; {
    description = "Create flat virtual Ethernet networks of almost unlimited size";
    homepage = "https://www.zerotier.com";
    license = licenses.bsl11;
    maintainers = with maintainers; [ sjmackenzie zimbatm ehmry obadz danielfullmer ];
    platforms = platforms.all;
  };
}
