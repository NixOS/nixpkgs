{
  pkgs ? import ../../.. { },
}:
let
  inherit (pkgs) runCommand;
  # splicing doesn't seem to work right here
  inherit (pkgs.buildPackages) dumpnar rsync nukeReferences;

  unpacked =
    let
      inherit (pkgs)
        bashNonInteractive
        binutils-unwrapped
        bzip2
        coreutils
        curl
        diffutils
        file
        findutils
        gawk
        gcc-unwrapped
        gitMinimal # for fetchgit (newlib-cygwin)
        gnugrep
        gnumake
        gnused
        gnutar
        gzip
        patch
        xz
        ;

      inherit (pkgs.cygwin)
        newlib-cygwin
        w32api
        ;

    in
    runCommand "unpacked"
      {
        nativeBuildInputs = [ nukeReferences ];
        # The result should not contain any references (store paths) so
        # that we can safely copy them out of the store and to other
        # locations in the store.
        allowedReferences = [ ];
        strictDeps = true;
      }
      ''
        mkdir -p "$out"/{bin,include,lib,libexec}
        cp -d "${bashNonInteractive}"/bin/* "$out"/bin/
        cp -d "${binutils-unwrapped}"/bin/* "$out"/bin/
        cp -d "${bzip2}"/bin/* "$out"/bin/
        cp -d "${coreutils}"/bin/* "$out"/bin/
        cp -d "${curl}"/bin/* "$out"/bin/
        cp -d "${diffutils}"/bin/* "$out"/bin/
        cp -d "${file}"/bin/* "$out"/bin/
        cp -d "${findutils}"/bin/* "$out"/bin/
        cp -d "${gawk}"/bin/* "$out"/bin/
        cp -d "${gcc-unwrapped}"/bin/* "$out"/bin/
        cp -rd ${gcc-unwrapped}/include/* $out/include/
        cp -rd ${gcc-unwrapped}/lib/* $out/lib/
        cp -rd ${gcc-unwrapped}/libexec/* $out/libexec/
        cp -frd ${gcc-unwrapped.lib}/bin/* $out/bin/
        cp -rd ${gcc-unwrapped.lib}/lib/* $out/lib/
        cp -d "${gitMinimal}"/bin/* "$out"/bin/
        cp -d "${gnugrep}"/bin/* "$out"/bin/
        cp -d "${gnumake}"/bin/* "$out"/bin/
        cp -d "${gnused}"/bin/* "$out"/bin/
        cp -d "${gnutar}"/bin/* "$out"/bin/
        (shopt -s dotglob; cp -d "${gzip}"/bin/* "$out"/bin/)
        cp -rd ${newlib-cygwin.dev}/include/* $out/include/
        cp -rd ${newlib-cygwin}/lib/* "$out"/lib/
        cp -d "${patch}"/bin/* "$out"/bin/
        cp -d "${w32api}"/lib/w32api/lib{advapi,shell,user,kernel}32.a "$out"/lib/
        cp -d "${xz}"/bin/* "$out"/bin/

        chmod -R +w "$out"

        find "$out" -type l -print0 | while read -d $'\0' link; do
          [[ -L "$link" && -e "$link" ]] || continue
          [[ $(realpath "$link") != "$out"* ]] || continue
          cp "$link" "$link"~
          mv "$link"~ "$link"
        done

        find "$out" -print0 | xargs -0 nuke-refs -e "$out"
      '';
in
{
  unpack = runCommand "unpack.nar.xz" {
    nativeBuildInputs = [ dumpnar ];
  } "dumpnar ${unpacked} | xz -9 -e -T $NIX_BUILD_CORES >$out";
}
