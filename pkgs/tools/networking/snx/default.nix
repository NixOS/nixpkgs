{ stdenv, fetchurl, makeWrapper, libX11, pam, gcc33 }:

let
  # The proper value for this offset can be found at the top of the snx_install script.
  archiveOffset = "78";
  libraryPath = stdenv.lib.makeSearchPath "lib" [libX11 pam gcc33.gcc];
in
stdenv.mkDerivation rec {
  name = "snx-800007027";

  src = fetchurl {
    url = "https://remote.us.publicisgroupe.net/CSHELL/snx_install.sh";
    sha256 = "1yq0r8gb6jw5pyfrw3wxvplrxxfhbhgm9ph4gyd754fyn52iwgxv";
  };

  buildInputs = [makeWrapper];

  unpackPhase = ''
    tail -n +${archiveOffset} ${src} | bunzip2 -c - | tar xfvp -
  '';

  buildPhase = ''
    patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" snx
  '';

  installPhase = ''
    mkdir -p "$out/sbin" "$out/libexec"
    mv snx "$out/libexec/"
    makeWrapper "$out/libexec/snx" "$out/sbin/snx" --prefix LD_LIBRARY_PATH ":" "${libraryPath}"
  '';

  meta = {
    homepage = "https://www.checkpoint.com/";
    description = "Check Point SSL Network Extender";
    license = "unknown";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
