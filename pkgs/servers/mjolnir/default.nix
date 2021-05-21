{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, makeWrapper
, nodejs
, pkgs
}:

stdenv.mkDerivation rec {
  pname = "mjolnir";
  version = "0.1.17";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "mjolnir";
    rev = "v${version}";
    sha256 = "uBI5AllXWgl3eL60WZ/j11Tt7QpY7CKcmFQOU74/Qjs=";
  };

  patches = [
    # catch errors and set non-zero exit code
    (fetchpatch {
      url = "https://github.com/matrix-org/mjolnir/pull/102/commits/662b06df8ef085fb78608ed19924383be62fa59f.patch";
      sha256 = "sha256-VUKFBMM67E8dGWSViDjMJadMS+DgvHvQS0aOnd2Fz/4=";
    })
  ];

  nativeBuildInputs = [
    nodejs
    makeWrapper
  ];

  buildPhase =
    let
      nodeDependencies = ((import ./node-composition.nix {
        inherit pkgs nodejs;
        inherit (stdenv.hostPlatform) system;
      }).nodeDependencies.override (old: {
        # access to path '/nix/store/...-source' is forbidden in restricted mode
        src = src;
        dontNpmInstall = true;
      }));
    in
    ''
      runHook preBuild

      ln -s ${nodeDependencies}/lib/node_modules .
      export PATH="${nodeDependencies}/bin:$PATH"
      npm run build

      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -a . $out/share/mjolnir

    makeWrapper ${nodejs}/bin/node $out/bin/mjolnir \
      --add-flags $out/share/mjolnir/lib/index.js

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "A moderation tool for Matrix";
    homepage = "https://github.com/matrix-org/mjolnir";
    longDescription = ''
      As an all-in-one moderation tool, it can protect your server from
      malicious invites, spam messages, and whatever else you don't want.
      In addition to server-level protection, Mjolnir is great for communities
      wanting to protect their rooms without having to use their personal
      accounts for moderation.

      The bot by default includes support for bans, redactions, anti-spam,
      server ACLs, room directory changes, room alias transfers, account
      deactivation, room shutdown, and more.

      A Synapse module is also available to apply the same rulesets the bot
      uses across an entire homeserver.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ jojosch ];
  };
}
