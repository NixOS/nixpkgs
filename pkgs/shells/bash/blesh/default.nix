{ lib
, stdenvNoCC
, fetchzip
, runtimeShell
, bashInteractive
, glibcLocales
}:

stdenvNoCC.mkDerivation rec {
  pname = "blesh";
  version = "0.3.4";

  src = fetchzip {
    url = "https://github.com/akinomyoga/ble.sh/releases/download/v${version}/ble-${version}.tar.xz";
    sha256 = "sha256-MGCQirZvqGfjTTsbDfihY2il/u2suWBaZ6dX8mF1zLk=";
  };

  dontBuild = true;

  doCheck = true;
  nativeCheckInputs = [ bashInteractive glibcLocales ];
  preCheck = "export LC_ALL=en_US.UTF-8";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/blesh/lib"

    cat <<EOF >"$out/share/blesh/lib/_package.sh"
    _ble_base_package_type=nix

    function ble/base/package:nix/update {
      echo "Ble.sh is installed by Nix. You can update it there." >&2
      return 1
    }
    EOF

    cp -rv $src/* $out/share/blesh

    runHook postInstall
  '';

  postInstall = ''
    mkdir -p "$out/bin"
    cat <<EOF >"$out/bin/blesh-share"
    #!${runtimeShell}
    # Run this script to find the ble.sh shared folder
    # where all the shell scripts are living.
    echo "$out/share/blesh"
    EOF
    chmod +x "$out/bin/blesh-share"
  '';

  meta = with lib; {
    homepage = "https://github.com/akinomyoga/ble.sh";
    description = "Bash Line Editor -- a full-featured line editor written in pure Bash";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aiotter ];
    platforms = platforms.unix;
  };
}
