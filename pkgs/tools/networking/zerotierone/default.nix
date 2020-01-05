{ stdenv, buildPackages, fetchFromGitHub, openssl, lzo, zlib, iproute, ronn }:

stdenv.mkDerivation rec {
  pname = "zerotierone";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "ZeroTierOne";
    rev = version;
    sha256 = "1f8hh05wx59dc0fbzdzwq05x0gmrdfl4v103wbcyjmzsbazaw6p3";
  };

  preConfigure = ''
      substituteInPlace ./osdep/ManagedRoute.cpp \
        --replace '/usr/sbin/ip' '${iproute}/bin/ip'

      substituteInPlace ./osdep/ManagedRoute.cpp \
        --replace '/sbin/ip' '${iproute}/bin/ip'

      patchShebangs ./doc/build.sh
      substituteInPlace ./doc/build.sh \
        --replace '/usr/bin/ronn' '${buildPackages.ronn}/bin/ronn' \
  '';


  nativeBuildInputs = [ ronn ];
  buildInputs = [ openssl lzo zlib iproute ];

  enableParallelBuilding = true;

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

  meta = with stdenv.lib; {
    description = "Create flat virtual Ethernet networks of almost unlimited size";
    homepage = https://www.zerotier.com;
    license = licenses.bsl11;
    maintainers = with maintainers; [ sjmackenzie zimbatm ehmry obadz danielfullmer ];
    platforms = with platforms; x86_64 ++ aarch64 ++ arm;
  };
}
