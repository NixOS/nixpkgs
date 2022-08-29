{ mkDerivation, fetchFromGitHub, lib, makeWrapper, pkg-config
, kcoreaddons, ki18n, kwallet, mksh, pinentry-qt }:

mkDerivation rec {
  pname = "kwalletcli";
  version = "3.03";

  src = fetchFromGitHub {
    owner = "MirBSD";
    repo = pname;
    rev = "${pname}-${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256-DUtaQITzHhQrqA9QJd0U/5EDjH0IzY9/kal/7SYQ/Ck=";
  };

  postPatch = ''
    substituteInPlace GNUmakefile \
      --replace -I/usr/include/KF5/KCoreAddons -I${kcoreaddons.dev}/include/KF5/KCoreAddons \
      --replace -I/usr/include/KF5/KI18n       -I${ki18n.dev}/include/KF5/KI18n \
      --replace -I/usr/include/KF5/KWallet     -I${kwallet.dev}/include/KF5/KWallet \
      --replace /usr/bin                       $out/bin \
      --replace /usr/share/man                 $out/share/man

    substituteInPlace pinentry-kwallet \
      --replace '/usr/bin/env mksh' ${mksh}/bin/mksh

    substituteInPlace kwalletcli_getpin \
      --replace '/usr/bin/env mksh' ${mksh}/bin/mksh
  '';

  makeFlags = [ "KDE_VER=5" ];

  nativeBuildInputs = [ makeWrapper pkg-config ];
  # if using just kwallet, cmake will be added as a buildInput and fail the build
  propagatedBuildInputs = [ kcoreaddons ki18n (lib.getLib kwallet) ];

  preInstall = ''
    mkdir -p $out/bin $out/share/man/man1
  '';

  postInstall = ''
    wrapProgram $out/bin/pinentry-kwallet \
      --prefix PATH : $out/bin:${lib.makeBinPath [ pinentry-qt ]} \
      --set-default PINENTRY pinentry-qt
    wrapProgram $out/bin/kwalletcli_getpin \
      --prefix PATH : $out/bin:${lib.makeBinPath [ pinentry-qt ]} \
      --set-default PINENTRY pinentry-qt
  '';

  meta = with lib; {
    description = "Command-Line Interface to the KDE Wallet";
    homepage = "https://www.mirbsd.org/kwalletcli.htm";
    license = licenses.miros;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
