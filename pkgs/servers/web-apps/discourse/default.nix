{ stdenv
, bundlerEnv
, fetchFromGitHub
, ruby
, writeScript
, coreutils
, curl
, gnugrep
, jq
, common-updater-scripts
, nix
, runtimeShell
, gnutar
, gzip
, svgo
}:

let
  env = bundlerEnv {
    name = "discourse";
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };

in stdenv.mkDerivation rec {
  pname = "discourse";
  version = "2.3.0.beta8";

  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse";
    rev = "v${version}";
    sha256 = "17ljrjsgi199wvg407m836bzp1shrnfriaq1wickqxc62g38nraa";
  };

  buildInputs = [
    env.wrappedRuby
    env.bundler
    env
    svgo
  ];

  installPhase = ''
    mkdir -p $out/share
    cp -r . $out/share/discourse
  '';

  passthru = {
    inherit env ruby;
    updateScript = import ./update.nix {
      inherit writeScript coreutils curl gnugrep jq common-updater-scripts
        nix runtimeShell gnutar gzip;
      inherit (stdenv) lib;
    };
  };

  meta = with stdenv.lib; {
    description = "A platform for community discussion. Free, open, simple.";
    homepage = https://www.discourse.org;
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
