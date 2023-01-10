{ lib
, stdenvNoCC
, fetchzip
, runtimeShell
, bashInteractive
, glibcLocales
}:

stdenvNoCC.mkDerivation rec {
  name = "blesh";
  version = "unstable-2022-07-29";

  src = fetchzip {
    url = "https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly-20220729+a22e145.tar.xz";
    sha256 = "088jv02y40pjcfzgrbx8n6aksznfh6zl0j5siwfw3pmwn3i16njw";
  };

  dontBuild = true;

  doCheck = true;
  checkInputs = [ bashInteractive glibcLocales ];
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
