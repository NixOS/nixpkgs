{ stdenv, lib, fetchFromGitHub, cmake, libevent }:

stdenv.mkDerivation rec {
  pname = "libevhtp";
  version = "unstable-2021-04-28";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "libevhtp";
    rev = "18c649203f009ef1d77d6f8301eba09af3777adf";
    sha256 = "1rf0jcy2lf8jbzpkhfgv289hc8zdy5zs6sn36k4vlqvilginxiid";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libevent ];

  cmakeFlags = [
    "-DEVHTP_DISABLE_SSL=ON"
    "-DEVHTP_BUILD_SHARED=ON"
  ];

  meta = with lib; {
    description = "Create extremely-fast and secure embedded HTTP servers with ease";
    homepage = "https://github.com/criticalstack/libevhtp";
    license = licenses.bsd3;
    maintainers = with maintainers; [ greizgh schmittlauch ];
  };
}
