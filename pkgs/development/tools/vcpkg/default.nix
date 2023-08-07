{ fetchFromGitHub
, makeWrapper
, stdenv
, jq
, runtimeShell
, lib
, vcpkg-tool
}:
stdenv.mkDerivation rec {
  pname = "vcpkg";
  version = "2023.07.21";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vcpkg";
    rev = "2023.07.21";
    hash = "sha256-GxBzP8Exupvr7Zt6Txq5wQGzL3N8VwlGYPaRbF291sI=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  # vcpkg needs to be able to write to VCPKG_ROOT, and requires the executable to be in VCPKG_ROOT
  # One way to achieve that would be to write a nixos module, but it would be better to be able to
  # use vcpkg in a nix-shell
  # So here's a wrapper script that will use the current user's home directory to store vcpgk's data
  # Note: we cannot use writeShellScript, because the placeholder would refer to the script itself
  vcpkgScript =
    let
      out = placeholder "out";
    in
    ''
    #!${runtimeShell}
    vcpkg_root_path="$HOME/.local/share/vcpkg/root/"

    if [[ ! -d "$vcpkg_root_path" ]]; then
      mkdir -p "$vcpkg_root_path"
      touch "$vcpkg_root_path/.vcpkg-root"
      touch "$vcpkg_root_path/vcpkg.disable-metrics"
    fi

    # Always take control of the root by linking current triplets
    # We should sent a MR to vcpkg-tool to add an argument to set the builtin-triplets
    rm -f "$vcpkg_root_path/triplets"
    ln -s ${out}/share/vcpkg/triplets "$vcpkg_root_path"

    # vcpkg needs to copy its own licence file for some reason.
    # If vcpkg can understand that we can set the root in a immutable filesystem,
    # we'll be able to drop this one
    rm -f "$vcpkg_root_path/LICENSE.txt"
    ln -s ${out}/share/vcpkg/LICENSE.txt "$vcpkg_root_path"

    # vcpkg cmake script tries to bootstrap if exe is not found
    touch "$vcpkg_root_path/vcpkg"

    # this is not strictly needed, but it makes it easier for the user to find the cmake toolchain file
    rm -f "$vcpkg_root_path/scripts"
    ln -s ${out}/share/vcpkg/scripts "$vcpkg_root_path/"

    # TODO: Make it change the root only if the vcpkg-root is either unset or set to the share dir
    # If we do that, we'll be able to drop the patch
    ${vcpkg-tool}/bin/vcpkg \
      --vcpkg-root="$vcpkg_root_path" \
      --x-scripts-root="${out}/share/vcpkg/scripts" \
      --x-builtin-ports-root="${out}/share/vcpkg/ports" \
      --x-builtin-registry-versions-dir="${out}/share/vcpkg/versions" "$@"
  '';

  vcpkgPatchRemoveRootArgument = builtins.readFile ./patches/remove-root-argument.diff;

  passAsFile = [ "vcpkgScript" "vcpkgPatchRemoveRootArgument" ];

  # This list contains the ports that fail to build
  # They are replaced by a dummy port that will tell the user to install them with Nix
  # It is not exhaustive, but can be extended with an overlay
  nativePackages = [
    "gettext"
    "qt"
    "qt5"
  ];

  postInstall = ''
    mkdir -p $out/bin $out/share/vcpkg/scripts/buildsystems
    cp --preserve=mode -r ${src}/{docs,ports,triplets,scripts,.vcpkg-root,versions,LICENSE.txt} $out/share/vcpkg/
    cp $vcpkgScriptPath $out/bin/vcpkg
    chmod +x $out/bin/vcpkg
    ln -s $out/bin/vcpkg $out/share/vcpkg/vcpkg
    touch $out/share/vcpkg/vcpkg.disable-metrics
  '';

  postFixup = ''
    # instead of fixing all the ports manually, we prompt the user to install them using Nix
    # in the future, a better solution would be to generate a nix derivation from
    # the vcpkg manifest
    for port in ${lib.concatStringsSep " " nativePackages}
    do
      portfile=$out/share/vcpkg/ports/$port/portfile.cmake
      echo 'set(VCPKG_POLICY_EMPTY_PACKAGE enabled)' > $portfile
      echo "message(WARNING Please install $port with Nix)" >> $portfile

      # We're going to manipulate the vcpkg.json here
      # We want to preserve the structure, but remove all dependencies
      manifest=$out/share/vcpkg/ports/$port/vcpkg.json
      ${jq}/bin/jq 'walk(if type == "object" and has("dependencies") then .dependencies = [] else . end)' \
        $manifest > result.json
      mv result.json $manifest
    done

    patch -i $vcpkgPatchRemoveRootArgumentPath $out/share/vcpkg/scripts/buildsystems/vcpkg.cmake
  '';

  meta = with lib; {
    description = "C++ Library Manager";
    homepage = "https://vcpkg.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ guekka gracicot ];
  };
}
