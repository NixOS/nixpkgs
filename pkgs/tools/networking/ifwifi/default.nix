{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  networkmanager,
  iw,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "ifwifi";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "araujobsd";
    repo = "ifwifi";
    rev = version;
    sha256 = "sha256-DPMCwyKqGJrav0wASBky9bS1bvJ3xaGsDzsk1bKaH1U=";
  };

  cargoHash = "sha256-TL7ZsRbpRdYymJHuoCUCqe/U3Vacb9mtKFh85IOl+PA=";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optional stdenv.hostPlatform.isDarwin Security;

  postInstall = ''
    wrapProgram "$out/bin/ifwifi" \
      --prefix PATH : "${
        lib.makeBinPath (
          # `ifwifi` runtime dep
          [ networkmanager ]
          # `wifiscanner` crate's runtime deps
          ++ (lib.optional stdenv.hostPlatform.isLinux iw)
          # ++ (lib.optional stdenv.hostPlatform.isDarwin airport) # airport isn't packaged
        )
      }"
  '';

  doCheck = true;

  meta = with lib; {
    description = "Simple wrapper over nmcli using wifiscanner made in rust";
    mainProgram = "ifwifi";
    longDescription = ''
      In the author's words:

      I felt bothered because I never remember the long and tedious command
      line to setup my wifi interface. So, I wanted to develop something
      using rust to simplify the usage of nmcli, and I met the wifiscanner
      project that gave me almost everything I wanted to create this tool.
    '';
    homepage = "https://github.com/araujobsd/ifwifi";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ blaggacao ];
    # networkmanager doesn't work on darwin
    # even though the `wifiscanner` crate would work
    platforms = with platforms; linux; # ++ darwin;
  };
}
