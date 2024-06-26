{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  version = "0.1.4";
  pname = "rconc";

  src = fetchFromGitHub {
    owner = "klemens";
    repo = pname;
    rev = "11def656970b9ccf35c40429b5c599a4de7b28fc";
    sha256 = "sha256-6Bff9NnG1ZEQhntzH5Iq0XEbJBKdwcb0BOn8nCkeWTY=";
  };

  cargoSha256 = "sha256-rSN/wm52ZhJ8JUEUC51Xv5eIpwvOR3LvTdFjGl64VVk=";

  meta = with lib; {
    description = "Simple cross-platform RCON client written in rust";
    homepage = "https://github.com/klemens/rconc";
    license = licenses.gpl3Only;
    mainProgram = "rconc";
  };
}
