{ lib
, stdenv
, fetchFromGitHub
, buildGoModule
, runCommand
, nix-update-script
, dsq
, diffutils
}:

buildGoModule rec {
  pname = "dsq";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "multiprocessio";
    repo = "dsq";
    rev = version;
    hash = "sha256-6Rdw/bXIcIoQ/PsVtJKSlwIhCxSlISPmmb2lGbp8vVM=";
  };

  vendorSha256 = "sha256-hZeI1XqW1lk9F66TVirkpvCZrJb9MO8aS1Sx/R92ddc=";

  nativeBuildInputs = [ diffutils ];

  passthru = {
    updateScript = nix-update-script { attrPath = pname; };

    tests = {
      pretty-csv = runCommand "${pname}-test" { } ''
        mkdir "$out"
        cat <<EOF > "$out/input.csv"
        first,second
        1,a
        2,b
        EOF
        cat <<EOF > "$out/expected.txt"
        +-------+--------+
        | first | second |
        +-------+--------+
        |     1 | a      |
        |     2 | b      |
        +-------+--------+
        EOF
        ${dsq}/bin/dsq --pretty "$out/input.csv" 'select first, second from {}' > "$out/actual.txt"
        diff "$out/expected.txt" "$out/actual.txt"
      '';
    };
  };

  meta = with lib; {
    description = "Commandline tool for running SQL queries against JSON, CSV, Excel, Parquet, and more";
    homepage = "https://github.com/multiprocessio/dsq";
    license = licenses.asl20;
    maintainers = with maintainers; [ liff ];
    # TODO: Remove once nixpkgs uses macOS SDK 10.14+ for x86_64-darwin
    # Undefined symbols for architecture x86_64: "_SecTrustEvaluateWithError"
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
