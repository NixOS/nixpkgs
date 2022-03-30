{ lib, fetchFromGitHub, rustPlatform, openssl, pam, pkg-config, sqlite, udev }:

rustPlatform.buildRustPackage rec {
  pname = "kanidm";
  version = "1.1.0-alpha.7";

  src = fetchFromGitHub {
    owner = "kanidm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-C+ITINRQLJjC8sL2PKvnnHHdLQ3y5OWz0wNMDfmn2vw=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl pam sqlite udev ];

  KANIDM_BUILD_PROFILE = "nixpkgs_profile";

  preBuild = ''
    cat > ./profiles/nixpkgs_profile.toml <<EOF
      web_ui_pkg_path = "${placeholder "out"}/share/webui/pkg"
      # Valid options are none, native, x86_64_v1, x86_64_v3
      cpu_flags = "none"
    EOF
  '';

  cargoBuildFlags = [
    # Only package things we care about, i.e. don't package orca (load testing tool)
    # https://github.com/kanidm/kanidm/blob/5cb429904df2ad21a5a97037ce9197f03d8eb470/Cargo.toml#L7-L20
    # This sequence of packages gets 100% of the kanidm commands, and no orca, at the time of writing
    "--package" "kanidm"
    "--package" "kanidm_tools"
    "--package" "kanidm_unix_int"
  ];

  cargoSha256 = "sha256-Cm3gNm3amUsJxDPsXDsGr+lFnN+H6XzIp4UmiUIdofM=";

  postInstall = ''
    mkdir -p $out/share/webui/
    cp --recursive ./kanidmd_web_ui/pkg $out/share/webui/pkg
  '';

  preCheck = ''
    # Use the default build profile so the tests can find the web ui
    unset KANIDM_BUILD_PROFILE
  '';

  meta = with lib; {
    description = "A simple, secure and fast identity management platform ";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ euank ];
  };
}
