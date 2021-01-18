{ lib, stdenv, buildPackages, fetchFromGitHub, openssl, lzo, zlib, iproute, ronn }:

stdenv.mkDerivation rec {
  pname = "zerotierone";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "ZeroTierOne";
    rev = version;
    sha256 = "0lky68fjrqjsd62g97jkn5a9hzj53g8wb6d2ncx8s21rknpncdar";
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
