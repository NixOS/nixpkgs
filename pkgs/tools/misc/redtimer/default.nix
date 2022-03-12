{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, ruby
, bundlerEnv
, livesplit-core
, ncurses
, toilet
}:

let
  gems = bundlerEnv {
    name = "redtimer-env";
    gemdir = ./.;
    inherit ruby;
  };
in
stdenv.mkDerivation rec {
  pname = "redtimer";
  version = "unstable-2021-08-01";

  src = fetchFromGitHub {
    owner = "cout";
    repo = pname;
    rev = "ab5ac1b527d670bc390456d68f3520cd8bd8e1cc";
    sha256 = "1ghlqir088azr65nzbaw2i2g4k417rfx5n8h2c3pywysv2vfxk0y";
  };

  preConfigure = ''
    ln -s ${livesplit-core}/lib/liblivesplit_core.so .
    ln -s ${livesplit-core}/lib/bindings/LiveSplitCore.rb .
  '';

  nativeBuildInputs = [ makeWrapper ruby gems toilet ];
  buildInputs = [ ncurses ];

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp -r * $out/share

    makeWrapper ${gems}/bin/bundle $out/bin/redtimer \
      --add-flags "exec ${ruby}/bin/ruby $out/share/bin/redtimer.rb" \
      --suffix PATH : ${lib.makeBinPath [ toilet ] } \
      --run "cd $out/share" # Depends on being ran from the projects root
  '';

  meta = with lib; {
    description = "A speedrunning timer for the terminal with support for autosplitting";
    homepage = "https://github.com/cout/redtimer";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.ivar ];
  };
}
