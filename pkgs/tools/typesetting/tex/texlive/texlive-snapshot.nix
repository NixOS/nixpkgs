{ pkgs ? import <nixpkgs> { } }:

/* To update texlive-snapshot.json run

   > nix-build texlive-snapshot.nix
   > cp result texlive-snapshot.json
 */

let tlpdb = pkgs.fetchurl {
  url = "https://texlive.info/tlnet-archive/2021/04/08/tlnet/tlpkg/texlive.tlpdb.xz";
  hash = "sha512-4LM0l1w10VUvmG9HzS3FHS8Ly1o8r8vXD8mknq8pZbE0sv+0lympuZX3Hlx6nr1nGY+DRh8GB1848QhSfxGpWw==";
  name = "texlive-snapshot-texlive.tlpdb.xz";
};
in
pkgs.runCommandLocal "texlive-snapshot.tlpdb.json"
{
  nativeBuildInputs = with pkgs; [ perl xz ];
}
  ''
    unxz --stdout "${tlpdb}" | perl "${./tlpdb2json.pl}" > "$out"
  ''
