{ lib, stdenv, fetchurl, dpkg, buildFHSUserEnv
, glibc, glib, openssl, tpm2-tss
, gtk3, gnome, polkit, polkit_gnome
}:

let
  pname = "beyond-identity";
  version = "2.60.0-0";
  libPath = lib.makeLibraryPath ([ glib glibc openssl tpm2-tss gtk3 gnome.gnome-keyring polkit polkit_gnome ]);
  meta = with lib; {
    description = "Passwordless MFA identities for workforces, customers, and developers";
    homepage = "https://www.beyondidentity.com";
    downloadPage = "https://app.byndid.com/downloads";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ klden ];
    platforms = [ "x86_64-linux" ];
  };

  beyond-identity = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchurl {
      url = "https://packages.beyondidentity.com/public/linux-authenticator/deb/ubuntu/pool/focal/main/b/be/${pname}_${version}/${pname}_${version}_amd64.deb";
      sha512 = "sha512-JrHLf7KkJVbJLxx54OTvOSaIzY3+hjX+bpkeBHKX23YriCJssUUvEP6vlbI4r6gjMMFMhW92k0iikAgD1Tr4ug==";
    };

    nativeBuildInputs = [
      dpkg
    ];

    unpackPhase = ''
      dpkg -x $src .
    '';

    installPhase = ''
      mkdir -p $out/opt/beyond-identity

      rm -rf usr/share/doc

      # https://github.com/NixOS/nixpkgs/issues/42117
      sed -i -e 's/auth_self/yes/g' usr/share/polkit-1/actions/com.beyondidentity.endpoint.stepup.policy

      cp -ar usr/{bin,share} $out
      cp -ar opt/beyond-identity/bin $out/opt/beyond-identity

      ln -s $out/opt/beyond-identity/bin/* $out/bin/
    '';

    postFixup = ''
      substituteInPlace \
        $out/share/applications/com.beyondidentity.endpoint.BeyondIdentity.desktop \
        --replace /usr/bin/ $out/bin/
      substituteInPlace \
        $out/share/applications/com.beyondidentity.endpoint.webserver.BeyondIdentity.desktop \
        --replace /opt/ $out/opt/
      substituteInPlace \
        $out/opt/beyond-identity/bin/byndid-web \
        --replace /opt/ $out/opt/
      substituteInPlace \
        $out/bin/beyond-identity \
        --replace /opt/ $out/opt/ \
        --replace /usr/bin/gtk-launch ${gtk3}/bin/gtk-launch

      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        --force-rpath \
        $out/bin/byndid
    '';
  };
# /usr/bin/pkcheck is hardcoded in binary - we need FHS
in buildFHSUserEnv {
   inherit meta;
   name = pname;

   targetPkgs = pkgs: [
     beyond-identity
     glib glibc openssl tpm2-tss
     gtk3 gnome.gnome-keyring
     polkit polkit_gnome
   ];

   extraInstallCommands = ''
     ln -s ${beyond-identity}/share $out
   '';

   runScript = "beyond-identity";
}

