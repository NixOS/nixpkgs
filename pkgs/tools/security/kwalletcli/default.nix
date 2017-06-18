{
  mkDerivation, fetchurl, lib,
  pkgconfig,
  kcoreaddons, ki18n, kwallet,
  mksh
}:

let
  pname = "kwalletcli";
  version = "3.00";
in
mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://www.mirbsd.org/MirOS/dist/hosted/kwalletcli/${name}.tar.gz";
    sha256 = "1q87nm7pkmgvkrml6hgbmv0ddx3871w7x86gn90sjc3vw59qfh98";
  };

  postPatch = ''
    substituteInPlace GNUmakefile \
      --replace '-I/usr/include/KF5/KCoreAddons' '-I${kcoreaddons.dev}/include/KF5/KCoreAddons' \
      --replace '-I/usr/include/KF5/KI18n'       '-I${ki18n.dev}/include/KF5/KI18n' \
      --replace '-I/usr/include/KF5/KWallet'     '-I${kwallet.dev}/include/KF5/KWallet' \
      --replace /usr/bin                         $out/bin \
      --replace /usr/share/man                   $out/share/man
  '';

  makeFlags = [ "KDE_VER=5" ];

  # we need this when building against qt 5.8+
  NIX_CFLAGS_COMPILE = [ "-std=c++11" ];

  nativeBuildInputs = [ pkgconfig ];
  # if using just kwallet, cmake will be added as a buildInput and fail the build
  propagatedBuildInputs = [ kcoreaddons ki18n (lib.getLib kwallet) ];
  propagatedUserEnvPkgs = [ mksh ];

  preInstall = ''
    mkdir -p $out/bin $out/share/man/man1
  '';

  meta = with lib; {
    description = "Command-Line Interface to the KDE Wallet";
    homepage = http://www.mirbsd.org/kwalletcli.htm;
    license = licenses.miros;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
