{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "hck";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-L/jad3T89VFub0JBC/o/xc4RI+/tF0hbhZdSxmSs+lo=";
  };

  cargoHash = "sha256-9v3yZNKBZ0XQkA7J50GH/Z4JQUQ48HnjNXr90ZBHXgI=";

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A close to drop in replacement for cut that can use a regex delimiter instead of a fixed string";
    homepage = "https://github.com/sstadick/hck";
    changelog = "https://github.com/sstadick/hck/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      mit # or
      unlicense
    ];
    maintainers = with maintainers; [
      figsoda
      gepbird
    ];
    mainProgram = "hck";
  };
}
