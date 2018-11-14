{ stdenv, appleDerivation, xcbuildHook }:

appleDerivation rec {
  nativeBuildInputs = [ xcbuildHook ];

  patchPhase = ''
    substituteInPlace rpcgen/rpc_main.c \
      --replace "/usr/bin/cpp" "${stdenv.cc}/bin/cpp"
  '';

  # temporary install phase until xcodebuild has "install" support
  installPhase = ''
    mkdir -p $out/bin/
    install Products/Release/* $out/bin/

    for n in 1; do
      mkdir -p $out/share/man/man$n
      install */*.$n $out/share/man/man$n
    done
  '';

  meta = {
    platforms = stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ matthewbauer ];
  };
}
