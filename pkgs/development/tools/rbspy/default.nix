{ stdenv, rustPlatform, fetchFromGitHub, lib, ruby, which}:
rustPlatform.buildRustPackage rec {
  pname = "rbspy";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "FnUUX7qQWVZMHtWvneTLzBL1YYwF8v4e1913Op4Lvbw=";
  };

  cargoSha256 = "98vmUoWSehX/9rMlHNSvKHJvJxW99pOhS08FI3OeLGo=";
  doCheck = true;

  # Tests in initialize.rs rely on specific PIDs being queried and attaching
  # tracing to forked processes, which don't work well with the isolated build.
  preCheck = ''
    substituteInPlace src/core/process.rs \
      --replace /usr/bin/which '${which}/bin/which'
    substituteInPlace src/sampler/mod.rs \
      --replace /usr/bin/which '${which}/bin/which'
    substituteInPlace src/core/initialize.rs \
      --replace 'fn test_initialize_with_disallowed_process(' '#[ignore] fn test_initialize_with_disallowed_process(' \
      --replace 'fn test_get_exec_trace(' '#[ignore] fn test_get_exec_trace(' \
  '';

  nativeBuildInputs = [ ruby which ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    homepage = "https://rbspy.github.io/";
    description = ''
      A Sampling CPU Profiler for Ruby.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
