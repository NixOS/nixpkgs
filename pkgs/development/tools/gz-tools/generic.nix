{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ruby,
  gz-cmake,
}:

{
  version,
  hash ? lib.fakeHash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gz-tools";
  inherit version;

  src = fetchFromGitHub rec {
    owner = "gazebosim";
    repo = "gz-tools";
    tag = "${if lib.versionAtLeast finalAttrs.version "2.0.0" then "gz-tools" else "ignition-tools"}${
      if lib.versions.major finalAttrs.version != "1" then lib.versions.major finalAttrs.version else ""
    }_${finalAttrs.version}";
    inherit hash;
  };

  nativeBuildInputs = [
    cmake
    gz-cmake
  ];
  buildInputs = [
    ruby
  ];

  postFixup = ''
    patchShebangs --build $out
  '';

  meta = {
    homepage = "https://bitbucket.org/ignitionrobotics/ign-tools";
    description = "Ignition entry point for using all the suite of ignition tools";
    mainProgram = if lib.versionAtLeast finalAttrs.version "2.0.0" then "gz" else "ign";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      pandapip1
      lopsided98
    ];
  };
})
