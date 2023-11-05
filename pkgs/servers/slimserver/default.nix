{ faad2
, fetchFromGitHub
, flac
, lame
, lib
, makeWrapper
, monkeysAudio
, nixosTests
, perl536Packages
, sox
, stdenv
, wavpack
, zlib
, enableUnfreeFirmware ? false
}:

let
  perlPackages = perl536Packages;
in
perlPackages.buildPerlPackage rec {
  pname = "slimserver";
  version = "8.3.1";

  src = fetchFromGitHub {
    owner = "Logitech";
    repo = "slimserver";
    rev = version;
    hash = "sha256-yMFOwh/oPiJnUsKWBGvd/GZLjkWocMAUK0r+Hx/SUPo=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ perlPackages.CryptOpenSSLRSA perlPackages.IOSocketSSL ];

  prePatch = ''
    rm -rf Bin

    ${lib.optionalString (!enableUnfreeFirmware) ''
      # remove unfree firmware
      rm -rf Firmware
    ''}

    touch Makefile.PL
  '';

  doCheck = false;

  installPhase = ''
    cp -r . $out
    wrapProgram $out/slimserver.pl \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ zlib stdenv.cc.cc.lib ]}" \
      --prefix PATH : "${lib.makeBinPath [ lame flac faad2 sox monkeysAudio wavpack ]}"
  '';

  outputs = [ "out" ];

  passthru.tests = {
    inherit (nixosTests) slimserver;
  };

  meta = with lib; {
    homepage = "https://github.com/Logitech/slimserver";
    description = "Server for Logitech Squeezebox players. This server is also called Logitech Media Server";
    # the firmware is not under a free license, but not included in the default package
    # https://github.com/Logitech/slimserver/blob/public/8.3/License.txt
    license = if enableUnfreeFirmware then licenses.unfree else licenses.gpl2Only;
    maintainers = with maintainers; [ adamcstephens jecaro ];
    platforms = platforms.unix;
  };
}
