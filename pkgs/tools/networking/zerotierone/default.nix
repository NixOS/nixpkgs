{ lib, stdenv, buildPackages, fetchFromGitHub, openssl, lzo, zlib, iproute, ronn }:

stdenv.mkDerivation rec {
  pname = "zerotierone";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "ZeroTierOne";
    rev = version;
    sha256 = "0a9sjcri96pv4pvvi94g7jyldwfhqqsi1k58maymm0jnqnj91z25";
  };

  preConfigure = ''
      patchShebangs ./doc/build.sh
      substituteInPlace ./doc/build.sh \
        --replace '/usr/bin/ronn' '${buildPackages.ronn}/bin/ronn' \

      substituteInPlace ./make-linux.mk \
        --replace 'armv5' 'armv6'
  '';


  nativeBuildInputs = [ ronn ];
  buildInputs = [ openssl lzo zlib iproute ];

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
