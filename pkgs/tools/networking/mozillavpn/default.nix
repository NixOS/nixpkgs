{ buildGoModule
, cargo
, cmake
, fetchFromGitHub
, go
, lib
<<<<<<< HEAD
, libcap
, libgcrypt
, libgpg-error
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libsecret
, pkg-config
, polkit
, python3
, qt5compat
, qtbase
, qtnetworkauth
, qtsvg
, qttools
, qtwebsockets
, rustPlatform
, rustc
, stdenv
, wireguard-tools
, wrapQtAppsHook
}:

let
  pname = "mozillavpn";
<<<<<<< HEAD
  version = "2.16.1";
=======
  version = "2.14.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "mozilla-mobile";
    repo = "mozilla-vpn-client";
    rev = "v${version}";
    fetchSubmodules = true;
<<<<<<< HEAD
    hash = "sha256-UMWBn3DoEU1fG7qh6F0GOhOqod+grPwp15wSSdP0eCo=";
  };
  patches = [ ];

  netfilterGoModules = (buildGoModule {
    inherit pname version src patches;
    modRoot = "linux/netfilter";
    vendorHash = "sha256-Cmo0wnl0z5r1paaEf1MhCPbInWeoMhGjnxCxGh0cyO8=";
  }).goModules;

  extensionBridgeDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}-extension-bridge";
    preBuild = "cd extension/bridge";
    hash = "sha256-1wYTRc+NehiHwAd/2CmsJNv/TV6wH5wXwNiUdjzEUIk=";
  };
  signatureDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}-signature";
    preBuild = "cd signature";
    hash = "sha256-oaKkQWMYkAy1c2biVt+GyjHBeYb2XkuRvFrWQJJIdPw=";
  };
  qtgleanDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}-qtglean";
    preBuild = "cd qtglean";
    hash = "sha256-cqfiOBS8xFC2BbYp6BJWK6NHIU0tILSgu4eo3Ik4YqY=";
=======
    hash = "sha256-xWm21guI+h0bKd/rEyxVMyxypCitLWEbVy7TaVBKh4o=";
  };

  netfilter-go-modules = (buildGoModule {
    inherit pname version src;
    modRoot = "linux/netfilter";
    vendorHash = "sha256-Cmo0wnl0z5r1paaEf1MhCPbInWeoMhGjnxCxGh0cyO8=";
  }).go-modules;

  extensionBridgeDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}-extension-bridge";
    preBuild = "cd extension/bridge";
    hash = "sha256-XW47EnNHm5JUWCqDU/iHB6ZRGny4v5x7Fs/1dv5TfzM=";
  };
  signatureDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}-signature";
    preBuild = "cd signature";
    hash = "sha256-CNPL1Orn+ZbX0HL+CHMaoXPI9G8MoC+hY8pJTJlWH1U=";
  };
  vpngleanDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}-vpnglean";
    preBuild = "cd vpnglean";
    hash = "sha256-5vazbCqzJG6iA0MFaTNha42jb1pgLhr0P9I8rQxSKtw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

in
stdenv.mkDerivation {
<<<<<<< HEAD
  inherit pname version src patches;

  buildInputs = [
    libcap
    libgcrypt
    libgpg-error
    libsecret
=======
  inherit pname version src;

  buildInputs = [
    libsecret
    polkit
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    qt5compat
    qtbase
    qtnetworkauth
    qtsvg
    qtwebsockets
  ];
  nativeBuildInputs = [
<<<<<<< HEAD
    cargo
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    cmake
    go
    pkg-config
    python3
    python3.pkgs.glean-parser
    python3.pkgs.pyyaml
    python3.pkgs.setuptools
<<<<<<< HEAD
    qttools
    rustPlatform.cargoSetupHook
=======
    rustPlatform.cargoSetupHook
    cargo
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    rustc
    wrapQtAppsHook
  ];

  postUnpack = ''
    pushd source/extension/bridge
    cargoDeps='${extensionBridgeDeps}' cargoSetupPostUnpackHook
    extensionBridgeDepsCopy="$cargoDepsCopy"
    popd

    pushd source/signature
    cargoDeps='${signatureDeps}' cargoSetupPostUnpackHook
    signatureDepsCopy="$cargoDepsCopy"
    popd

<<<<<<< HEAD
    pushd source/qtglean
    cargoDeps='${qtgleanDeps}' cargoSetupPostUnpackHook
    qtgleanDepsCopy="$cargoDepsCopy"
=======
    pushd source/vpnglean
    cargoDeps='${vpngleanDeps}' cargoSetupPostUnpackHook
    vpngleanDepsCopy="$cargoDepsCopy"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    popd
  '';
  dontCargoSetupPostUnpack = true;

  postPatch = ''
<<<<<<< HEAD
    substituteInPlace src/apps/vpn/cmake/linux.cmake \
      --replace '/etc/xdg/autostart' "$out/etc/xdg/autostart" \
=======
    substituteInPlace src/apps/vpn/platforms/linux/daemon/org.mozilla.vpn.dbus.service --replace /usr/bin/mozillavpn "$out/bin/mozillavpn"

    substituteInPlace scripts/addon/build.py \
      --replace 'qtbinpath = args.qtpath' 'qtbinpath = "${qttools.dev}/bin"' \
      --replace 'rcc = os.path.join(qtbinpath, rcc_bin)' 'rcc = "${qtbase.dev}/libexec/rcc"'

    substituteInPlace src/apps/vpn/cmake/linux.cmake \
      --replace '/etc/xdg/autostart' "$out/etc/xdg/autostart" \
      --replace '${"$"}{POLKIT_POLICY_DIR}' "$out/share/polkit-1/actions" \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      --replace '/usr/share/dbus-1' "$out/share/dbus-1" \
      --replace '${"$"}{SYSTEMD_UNIT_DIR}' "$out/lib/systemd/system"

    substituteInPlace extension/CMakeLists.txt \
      --replace '/etc' "$out/etc"

<<<<<<< HEAD
    ln -s '${netfilterGoModules}' linux/netfilter/vendor
=======
    ln -s '${netfilter-go-modules}' linux/netfilter/vendor
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    pushd extension/bridge
    cargoDepsCopy="$extensionBridgeDepsCopy" cargoSetupPostPatchHook
    popd

    pushd signature
    cargoDepsCopy="$signatureDepsCopy" cargoSetupPostPatchHook
    popd

<<<<<<< HEAD
    pushd qtglean
    cargoDepsCopy="$qtgleanDepsCopy" cargoSetupPostPatchHook
=======
    pushd vpnglean
    cargoDepsCopy="$vpngleanDepsCopy" cargoSetupPostPatchHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    popd

    cargoSetupPostPatchHook() { true; }
  '';

  cmakeFlags = [
    "-DQT_LCONVERT_EXECUTABLE=${qttools.dev}/bin/lconvert"
    "-DQT_LUPDATE_EXECUTABLE=${qttools.dev}/bin/lupdate"
    "-DQT_LRELEASE_EXECUTABLE=${qttools.dev}/bin/lrelease"
  ];
  dontFixCmake = true;

  qtWrapperArgs =
    [ "--prefix" "PATH" ":" (lib.makeBinPath [ wireguard-tools ]) ];

  meta = {
    description = "Client for the Mozilla VPN service";
    homepage = "https://vpn.mozilla.org/";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ andersk ];
    platforms = lib.platforms.linux;
  };
}
