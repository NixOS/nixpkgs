{ mkDerivation, fetchFromGitHub, lib, makeWrapper, pkgconfig
, kcoreaddons, ki18n, kwallet, mksh, pinentry_qt5 }:

mkDerivation rec {
  pname = "kwalletcli";
  version = "3.02";

  src = fetchFromGitHub {
    owner = "MirBSD";
    repo = pname;
    rev = "${pname}-${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "1gq45afb5nmmjfqxglv7wvcxcjd9822pc7nysq0350jmmmqwb474";
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
  '';

  makeFlags = [ "KDE_VER=5" ];

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  # if using just kwallet, cmake will be added as a buildInput and fail the build
  propagatedBuildInputs = [ kcoreaddons ki18n (lib.getLib kwallet) ];

  preInstall = ''
    mkdir -p $out/bin $out/share/man/man1
  '';

  postInstall = ''
    wrapProgram $out/bin/pinentry-kwallet \
      --prefix PATH : $out/bin:${lib.makeBinPath [ pinentry_qt5 ]} \
      --set-default PINENTRY pinentry-qt
  '';

  meta = with lib; {
    description = "Command-Line Interface to the KDE Wallet";
    homepage = https://www.mirbsd.org/kwalletcli.htm;
    license = licenses.miros;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
